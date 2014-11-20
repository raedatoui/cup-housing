package com.shashi.overlays.shp
{
	import com.modestmaps.Map;
	import com.modestmaps.core.Coordinate;
	import com.modestmaps.core.MapExtent;
	import com.modestmaps.core.TileGrid;
	import com.modestmaps.geo.Location;
	import com.modestmaps.overlays.Redrawable;
	
	import flash.display.BitmapData;
	import flash.display.LineScaleMode;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	import org.vanrijkom.shp.ShpPoint;
	import org.vanrijkom.shp.ShpPolygon;
	import org.vanrijkom.shp.ShpRecord;

	public class ShpPolygonMarker extends ShpMarker implements Redrawable
	{
		protected var map:Map;
		protected var drawZoom:Number;
		
		public var locations:Array;
		// an array of arrays of coordinates used to draw
		protected var coordinates:Array; // cached after converting locations with the map provider
		public var extent:MapExtent;
		
		public var zoomTolerance:Number = 4;
		
		public var line:Boolean = true;
		public var lineThickness:Number = 0;
		public var lineColor:uint = 0;
		public var lineAlpha:Number = 1;
		public var linePixelHinting:Boolean = false;
		public var lineScaleMode:String = LineScaleMode.NONE;
		public var lineCaps:String = null;
		public var lineJoints:String = null; 
		public var lineMiterLimit:Number = 3; 		

		public var fill:Boolean = true;
		public var fillColor:uint = 0xff0000;
		public var fillAlpha:Number = 0.2;
		
		public var bitmapFill:Boolean = false;
		public var bitmapData:BitmapData = null;
		public var bitmapMatrix:Matrix = null;
		public var bitmapRepeat:Boolean = false;
		public var bitmapSmooth:Boolean = false;
		
		protected var geometry:Array;
		
		/** 
		 * Creates a polygon from the given array (or array of arrays) of Locations.
		 * 
		 * The polygon will use the given map to project the locations, and should be added to an
		 * instance of ShpMarkerClip, which will add and remove it from the stage and position it
		 * as required.
		 * 
		 * If an array of arrays of Locations is given, the first array will be drawn as the outer
		 * ring of the polygon, and subsequent arrays will be treated as more rings [this is different
		 * from PolygonMarker - this is drawing rings like Hawaii's islands, that is drawing holes like lakes]
		 * 
		 */
		public function ShpPolygonMarker(map:Map, record:ShpRecord, fillColor:uint=0xFF0000)
		{
			this.id = record.number;
			this.fillColor = fillColor;
			this.map = map;
			this.geometry = (record.shape as ShpPolygon).rings;
			
			if (geometry && geometry.length > 0) {
				// not going to be the case with ShpRecord
				if (geometry[0] is Location && geometry.length > 0) {
					locations = [ locations ];
				}
				if (geometry[0] is Array && geometry[0][0] is Location && geometry[0].length > 0) {
					this.locations = [ geometry[0] ];
					this.extent = MapExtent.fromLocations(geometry[0]);
					this.location = geometry[0][0] as Location;
					this.coordinates = [ geometry[0].map(l2c) ];
					for each (var otherRing:Array in geometry.slice(1)) {
						this.coordinates.push( otherRing.map(l2c) );
					}					
				}
				else if (geometry[0] is Array && geometry[0][0] is ShpPoint && geometry[0].length > 0) {
					this.locations = [ geometry[0].map(shp2l) ];
					this.extent = MapExtent.fromLocations(locations[0]);
					this.location = locations[0][0];
					this.coordinates = [ geometry[0].map(shp2c) ];
					for each (var shpRing:Array in geometry.slice(1)) {
						this.coordinates.push( shpRing.map(shp2c) );
					}					
				}
				
//				updateGraphics();
			}
		}
		
		public function addHole(hole:Array):void
		{
			this.locations.push(hole);
			this.extent.encloseExtent(MapExtent.fromLocations(hole));
			this.coordinates.push(hole.map(l2c));	
			updateGraphics();
		}
		
		protected function shp2l(shp:ShpPoint, ...rest):Location
		{
			return shp.toLocation();
		}
		
		protected function shp2c(shp:ShpPoint, ...rest):Coordinate
		{
			return map.getMapProvider().locationCoordinate(shp.toLocation());
		}
		
		protected function l2c(l:Location, ...rest):Coordinate
		{
			return map.getMapProvider().locationCoordinate(l);
		}
	
		public function redraw(event:Event=null):void
		{	
			if (drawZoom && Math.abs(map.grid.zoomLevel-drawZoom) < zoomTolerance) {
				scaleX = scaleY = Math.pow(2, map.grid.zoomLevel-drawZoom);
			}
			else {
				updateGraphics();
			}
		}
		
		public function forceUpdate(event:Event=null):void
		{
			updateGraphics();
		}
		
		override public function draw():void
		{
			updateGraphics();
		}
		
		public function updateGraphics():void
		{
			var grid:TileGrid = map.grid;
			
			drawZoom = grid.zoomLevel;
			scaleX = scaleY = 1;
			
			graphics.clear();
			if (line) {
				graphics.lineStyle(lineThickness, lineColor, lineAlpha, linePixelHinting, lineScaleMode, lineCaps, lineJoints, lineMiterLimit);
			}
			else {
				graphics.lineStyle();
			}
			
			if (fill) {
				if (bitmapFill && bitmapData) {
					graphics.beginBitmapFill(bitmapData, bitmapMatrix, bitmapRepeat, bitmapSmooth);
				} 
				else {
					graphics.beginFill(fillColor, fillAlpha);
				}
			}
			
			// this is where the drawing is different from PolygonMarker
			if (location) {
				var firstPoint:Point = grid.coordinatePoint(coordinates[0][0]);
				for each (var ring:Array in coordinates) {
					var ringPoint:Point = grid.coordinatePoint(ring[0]);
					graphics.moveTo(ringPoint.x-firstPoint.x, ringPoint.y-firstPoint.y);
					var p:Point;
					for each (var coord:Coordinate in ring.slice(1)) {
						p = grid.coordinatePoint(coord);
						graphics.lineTo(p.x-firstPoint.x, p.y-firstPoint.y);
					}
		 			if (!ringPoint.equals(p)) {
						graphics.lineTo(ringPoint.x-firstPoint.x, ringPoint.y-firstPoint.y);
					}
				}
			}
			
			if (fill) {
				graphics.endFill();
			}
		}
	}
}