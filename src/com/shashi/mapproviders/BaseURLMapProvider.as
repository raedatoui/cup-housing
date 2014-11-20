package com.shashi.mapproviders
{
	import com.modestmaps.core.Coordinate;
	import com.modestmaps.mapproviders.OpenStreetMapProvider;
	
	public class BaseURLMapProvider extends OpenStreetMapProvider
	{
		public static const TONER:String = 'http://tile.stamen.com/toner-lite/';
		protected var baseURL:String = 'http://toner.stamen.com/{Z}/{X}/{Y}.png';
		
		public function BaseURLMapProvider(base:String, minZoom:int=MIN_ZOOM, maxZoom:int=MAX_ZOOM)
		{
			baseURL = base;
			super(minZoom, maxZoom);
		}
		
		override public function toString() : String
		{
			return "BASE_URL";
		}
		
		override public function getTileUrls(coord:Coordinate):Array
		{
			var sourceCoord:Coordinate = sourceCoordinate(coord);
			return [ baseURL +(sourceCoord.zoom)+'/'+(sourceCoord.column)+'/'+(sourceCoord.row)+'.png' ];
		}
	}
}