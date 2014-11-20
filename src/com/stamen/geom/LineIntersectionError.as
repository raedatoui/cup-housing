package com.stamen.geom
{
	public class LineIntersectionError extends Error
	{
		protected var _t:Number;

		public function LineIntersectionError(message:String, t:Number, id:int=0)
		{
			super(message, id);
			_t = t;
		}
		
		public function get t():Number
		{
			return _t;
		}
	}
}