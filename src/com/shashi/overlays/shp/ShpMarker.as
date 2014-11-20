package com.shashi.overlays.shp
{
	import com.modestmaps.geo.Location;
	
	import flash.display.Sprite;
	import flash.utils.Dictionary;

	/**
	 * Just a base class for point, polyline, and polygon features.
	 * 
	 * @author Andy Woodruff
	 */
	public class ShpMarker extends Sprite
	{
		/**
		 * A factor by which to increase the scale at which data are drawn and then shrunk down again.
		 * The reason for this is that geo-data are dealt with in terms of lat/long, which means
		 * very tiny distances for certain data sets. There is some minimum distance that Flash can
		 * draw, but we can fake it by drawing everything huge and then scaling the whole thing down
		 * afterward.
		 */
		protected var scaleFactor:Number = 500;
		
		public var location:Location;
		
		public var id:int = -1;
		
		/**
		 * Attribute values, with field names as keys. (If a DBF file was loaded.) 
		 */
		public var values:Dictionary;
		
		public var fields:Array;
		
		protected var shape:Sprite = new Sprite();
		
		public function ShpMarker()
		{
			super();
		}
		
		/**
		 * Draw the feature. 
		 */
		public function draw() : void
		{
			// override in subclasses
		}
		
	}
}