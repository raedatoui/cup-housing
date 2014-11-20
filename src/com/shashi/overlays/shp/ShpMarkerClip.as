package com.shashi.overlays.shp
{
	import com.modestmaps.Map;
	import com.modestmaps.overlays.MarkerClip;
	import com.modestmaps.overlays.Redrawable;
	import com.shashi.svg.ISVGExportable;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.external.ExternalInterface;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;
	
	import org.vanrijkom.dbf.DbfField;
	import org.vanrijkom.dbf.DbfHeader;
	import org.vanrijkom.dbf.DbfRecord;
	import org.vanrijkom.dbf.DbfTools;
	import org.vanrijkom.shp.ShpRecord;
	import org.vanrijkom.shp.ShpTools;
	import org.vanrijkom.shp.ShpType;

	public class ShpMarkerClip extends MarkerClip implements ISVGExportable
	{
		public static const DBF_LOADED:String = "attributes loaded";
		public static const SHP_LOADED:String = 'shp loaded';
		/**
		 * The geographic (e.g. states or countries) features contained in the shapefile.
		 */
		public var features : Array = new Array();
		public var records  : Array = [];
		
		public var attributeFields : Array;
		
		protected var dbfData:ByteArray;
		
		private var dataLoader:URLLoader = new URLLoader();
		private var shpLoaded:Boolean = false;
		
		public function ShpMarkerClip(map:Map, shpFile:String, shpDatabaseFile:String=null)
		{
			super(map);
			
			// load the shapefile
			
			ExternalInterface.call("alert","loading " + shpFile + " loading " + shpDatabaseFile);
			
			dataLoader.dataFormat = URLLoaderDataFormat.BINARY;
			dataLoader.load(new URLRequest(shpFile));
			dataLoader.addEventListener(Event.COMPLETE, onShapefileLoaded);
			dataLoader.addEventListener(IOErrorEvent.IO_ERROR, onShapefileError);
			
			if (shpDatabaseFile != null) {
				var dbfLoader:URLLoader = new URLLoader();
				dbfLoader.dataFormat = URLLoaderDataFormat.BINARY;
				dbfLoader.load(new URLRequest(shpDatabaseFile));
				dbfLoader.addEventListener(Event.COMPLETE, onDBF);
			}
		}
		
		public function load(shpFile:String, shpDatabaseFile:String=null):void
		{
			// 
		}
		
		protected function onShapefileLoaded(event:Event):void
		{
			ExternalInterface.call("alert","shp loaded");
			// use the ShpTools class to parse the shapefile into an array of records
			records = ShpTools.readRecords(event.target.data).records;
			
			if (records.length > 1000)
			{
				beginProgressiveLoad();
				return;
			}
			
			// create a feature (point, polyline, or polygon) from each record
			for each( var record:ShpRecord in records ){
				attachRecordAsFeature(record);
			}
			
			shpLoaded = true;
			dirty = true;
			updateClips();
		}
		
		protected function onShapefileError(event:IOErrorEvent):void
		{
			ExternalInterface.call("alert","error loading shp");
		}
		
		protected var currentRecord:int = 0;
		protected function beginProgressiveLoad():void
		{
			currentRecord = 0;
			addEventListener(Event.ENTER_FRAME, onProgressiveLoad);
		}
		
		protected function onProgressiveLoad(event:Event):void
		{
			var t:int = getTimer();
			while ((getTimer() - t) < 25 && currentRecord < records.length)
			{
				attachRecordAsFeature(records[currentRecord]);
				currentRecord++;
			}
			
			trace(currentRecord , records.length, 'shp progress');
			
			if (currentRecord >= records.length)
			{
				endProgressiveLoad();
			} 
		}
		
		protected function endProgressiveLoad(event:Event=null):void
		{
			removeEventListener(Event.ENTER_FRAME, onProgressiveLoad);
			trace('finished progressively loading');
			
			shpLoaded = true;
			dirty = true;
			
			if (dbfData)
				createAttributes(dbfData);
				
			updateClips();
			dispatchEvent(new Event(SHP_LOADED, true));
		}
		
		protected function attachRecordAsFeature(record:ShpRecord):void
		{
			var feature:ShpMarker = createFeature(record);
			if ( feature != null && feature.location) 
			{
				features.push( feature );
				attachMarker(feature, feature.location);
			}
		}
		
		/**
		 * Creates the appropriate type of feature for a record.
		 * @param record The source record.
		 * @return A point, polyline, or polygon feature.
		 * 
		 */
		protected var incrementColor:uint = 0x660000;
		protected function createFeature(record:ShpRecord):ShpMarker
		{
			incrementColor += 0x000022;
			var feature:ShpMarker;
			switch(record.shapeType) {
				
				case ShpType.SHAPE_POINT:
				feature = new ShpPointMarker(record);
				break;
				
				case ShpType.SHAPE_POLYLINE:
				feature = new ShpPolylineMarker(map, record, 1, 0);
				break;
				
				case ShpType.SHAPE_POLYGON:
				feature = new ShpPolygonMarker(map, record, incrementColor);
//				(feature as ShpPolygonMarker).fill = false;
//				(feature as ShpPolygonMarker).line = false;
//				feature.draw();
				break;
			}
			
			// other shape types will return null
			return feature;
		}
		
		// Event handler for DBF load.
		protected function onDBF( event:Event ):void
		{
			// Wait to create attributes until the shapefile is loaded.
			dbfData = (event.target as URLLoader).data;
			
			if (shpLoaded){
				createAttributes(dbfData);
			}
		}
		
		protected function createAttributes(dbf:ByteArray):void
		{
			var dbfHeader:DbfHeader = new DbfHeader(dbf);
			
			// Checking if the DBF has the same number of records as the shapefile is a basic test of whether the two files match.
			if (dbfHeader.recordCount != features.length) {
				throw new Error("Shapefile/DBF record count mismatch. Attributes were not loaded.");
				return;
			}
			
			// Populate attribute field names array.
			attributeFields = new Array();
			for each ( var field:DbfField in dbfHeader.fields ) {
				attributeFields.push( field.name );
			}
			
			// Assign attribute dictionaries to features.
			for ( var i:int = 0; i < dbfHeader.recordCount; i++ ) {
				var record:DbfRecord = DbfTools.getRecord(dbf, dbfHeader, i);
				features[i].values = record.values;
				features[i].fields = record.fieldNames;
			}
			
			dispatchEvent(new Event(DBF_LOADED,true));
		}
		
		public function export():String
		{
			var results:Array = [];
			for each (var feature:ShpMarker in features)
			{
				if (feature is ISVGExportable)
				{
					results.push((feature as ISVGExportable).export());
				}
			}
			return results.join('\n');
		}
		
		override public function updateClip(marker:DisplayObject):Boolean
		{
			// we need to redraw this marker before MarkerClip.updateClip so that markerInBounds will be correct
			if (marker is Redrawable) {
				Redrawable(marker).redraw();
			}
			return super.updateClip(marker);
		}
	}
}