package com.shashi.overlays.shp
{
	import com.modestmaps.Map;
	import com.modestmaps.core.Coordinate;
	import com.modestmaps.core.TileGrid;
	import com.modestmaps.geo.Location;
	import com.modestmaps.overlays.Polyline;
	import com.modestmaps.overlays.Redrawable;
	import com.shashi.svg.ISVGExportable;
	import com.shashi.svg.SVGPrinter;
	
	import flash.events.Event;
	import flash.geom.Point;
	
	import org.vanrijkom.shp.ShpPoint;
	import org.vanrijkom.shp.ShpPolyline;
	import org.vanrijkom.shp.ShpRecord;
	
	public class ShpPolylineMarker extends ShpMarker implements Redrawable, ISVGExportable
	{
		protected var line:Polyline;
		protected var map:Map;
		protected var drawZoom:Number;
		protected var zoomTolerance:int = 4;
		
		protected var coordinates:Array = [];
		
		public function ShpPolylineMarker(map:Map, record:ShpRecord, 
								 lineThickness:Number=3, 
								 lineColor:Number=0xFF0000, 
								 lineAlpha:Number=1, 
								 pixelHinting:Boolean=false, 
								 scaleMode:String="none", 
								 caps:String=null, 
								 joints:String=null, 
								 miterLimit:Number=3)
		{
			var pts:Array = (record.shape as ShpPolyline).rings;
			
			super();
			
			if (pts[0][0] is ShpPoint)
				this.location = (pts[0][0] as ShpPoint).toLocation();
			else if (pts[0][0] is Location)
				this.location = pts[0][0] as Location;
				
			var locations:Array = (pts[0] as Array).map(shp2l);
			
			this.id = record.number;
			this.map = map;
			this.coordinates = locations.map(l2c);
			
			line = new Polyline('', locations, lineThickness, lineColor, lineAlpha, pixelHinting, scaleMode, caps, joints, miterLimit);
			
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
		
		protected function c2p(c:Coordinate, ...rest):Point
		{
			return map.grid.coordinatePoint(c, map.stage);
		}
		
		public function set color(value:uint):void
		{
			line.lineColor = value;
			updateGraphics();
		}
		
		public function set stroke(value:Number):void
		{
			line.lineThickness = value;
			updateGraphics();
		}
		
		public function setStyle(
								 lineThickness:Number=3, 
								 lineColor:Number=0xFF0000, 
								 lineAlpha:Number=1, 
								 pixelHinting:Boolean=false, 
								 scaleMode:String="none", 
								 caps:String=null, 
								 joints:String=null, 
								 miterLimit:Number=3):void
		 {
		 	line.lineThickness = lineThickness;
		 	line.lineColor = lineColor;
		 	line.lineAlpha = lineAlpha;
		 	line.pixelHinting = pixelHinting;
		 	line.scaleMode = scaleMode;
		 	line.caps = caps;
		 	line.joints = joints;
		 	line.miterLimit = miterLimit;
		 	
		 	updateGraphics();
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
		
		public function export():String
		{
			var pts:Array = coordinates.map(c2p);
			return SVGPrinter.drawLine(pts, line.lineColor, line.lineAlpha, line.lineThickness, 0, 0, line.caps, line.joints, line.miterLimit);
		}
		
		protected function updateGraphics():void
		{
			var grid:TileGrid = map.grid;
			
			drawZoom = grid.zoomLevel;
			scaleX = scaleY = 1;
			
			graphics.clear();
			if (line) {
				graphics.lineStyle(line.lineThickness, line.lineColor, line.lineAlpha, line.pixelHinting, line.scaleMode, line.caps, line.joints, line.miterLimit);
			}
			else {
				graphics.lineStyle();
			}
			
			// this is where the drawing is different from PolygonMarker
			if (location) {
				var firstPoint:Point = grid.coordinatePoint(coordinates[0]);
				graphics.moveTo(0, 0);
				
				var p:Point;
				for each (var coord:Coordinate in coordinates) {
					p = grid.coordinatePoint(coord);
					graphics.lineTo(p.x-firstPoint.x, p.y-firstPoint.y);
				}
			}
			
			if (line) {
				graphics.lineStyle();
			}
		}
		
	}
}