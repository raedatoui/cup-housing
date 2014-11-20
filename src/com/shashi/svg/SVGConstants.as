package com.shashi.svg
{
	import flash.display.CapsStyle;
	import flash.display.JointStyle;
	import flash.geom.Point;
	
	public class SVGConstants
	{
		public function SVGConstants()
		{
		}
		
		public static const ORIGIN:Point = new Point();
		
		public static function getStyleString(	thickness:Number, color:uint, alpha:Number=1, fillColor:uint=0, fillAlpha:Number=0,
												capStyle:String=null, jointStyle:String=null, miter:Number=4):String
		{
			var styleStr:String = '';
			
			if (thickness > 0 && alpha != 0)
				styleStr = ' stroke="' + makeHex(color) + '"';
				
			styleStr = styleStr + ' fill="' + makeHex(fillColor) + '"';
			styleStr = styleStr + ' fill-opacity="' + fillAlpha + '"';
			
			if (thickness)
				styleStr = styleStr + ' stroke-width="' + thickness + '"';
			
			if (alpha == 0)
				styleStr = styleStr + ' stroke="none"';
			else if (alpha > 0)
				styleStr = styleStr + ' stroke-opacity="' + alpha + '"';
			
			if (capStyle)
				styleStr = styleStr + ' stroke-linecap="' + lineCap(capStyle) + '"';
				
			if (jointStyle)
				styleStr = styleStr + ' stroke-linejoin="' + lineJoin(jointStyle) + '"';
				
			if (miter != 4)
				styleStr = styleStr + ' stroke-miterlimit="' + miter + '"';
			
			return styleStr;
		}
		
		public static function makeHex(col:uint):String
		{
			var n:String = col.toString(16);
			
			while (n.length < 6)
			{
				n = '0' + n;
			}
			
			return '#' + n;
		}
		
		public static function lineCap(cap:String='none'):String
		{
			switch (cap)
			{
				case CapsStyle.SQUARE:
					return 'square';
				case CapsStyle.ROUND:
					return 'round';
				case CapsStyle.NONE:
				default:
					return 'butt';
			}
		}
		
		public static function lineJoin(join:String='miter'):String
		{
			switch (join)
			{
				case JointStyle.MITER:
					return 'miter';
				case JointStyle.ROUND:
					return 'round';
				case JointStyle.BEVEL:
					return 'bevel';
				default:
					return 'miter';
			}
		}
	}
}