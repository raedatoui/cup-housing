package com.shashi.svg
{
	import com.modestmaps.Map;
	import com.modestmaps.geo.Location;
	import com.modestmaps.overlays.Polyline;
	
	import flash.display.Sprite;
	import flash.geom.Point;
	
	public class SVGPrinter
	{
		public function SVGPrinter()
		{
		}
		
		public static function drawSprite(sprite:Sprite, fillColor:uint=0, fillAlpha:Number=0):String
		{
			var style:String = SVGConstants.getStyleString(0, 0, 0, fillColor, fillAlpha);
			var pt:Point = sprite.localToGlobal(SVGConstants.ORIGIN);
			
			return '<rect x="' + pt.x + '" y="' + pt.y + '" width="' + sprite.width + '" height="' + sprite.height + '" ' + style + ' />';
		}

		public static function drawCircleClass(cx:Number, cy:Number, r:Number, className:String):String
		{
			return '<circle cx="' + cx + '" cy="' + cy + '" r="' + r + '" class="' + className + '" />';
		}
		
//		<circle cx="100" cy="50" r="40" stroke="black" stroke-width="2" fill="red"/>
		public static function drawCircle(cx:Number, cy:Number, r:Number, strokeColor:uint, strokeAlpha:Number=1, thickness:Number=1, fillColor:uint=0, fillAlpha:Number=0):String
		{
			var style:String = SVGConstants.getStyleString(thickness, strokeColor, strokeAlpha, fillColor, fillAlpha);
			
			return '<circle cx="' + cx + '" cy="' + cy + '" r="' + r + '" ' + style + ' />';
		}
		
		public static function drawLineClass(pts:Array, className:String):String
		{
			if (pts.length > 1)
			{
				var line:String = '';
				var p:Point = pts.shift();
				line = '<path d="M ' + p.x + ' ' + p.y + ' L ';
				var all:Array = [];
				for each (var pt:Point in pts)
				{
					all.push(pt.x);
					all.push(pt.y);
				}
				
				line = line + all.join(' ') + '" ' + 'class="' + className + '" ' + '/>';
				return line;
			}
			
			return '';
		}
		
		public static function drawLine(pts:Array, strokeColor:uint, strokeAlpha:Number=1, thickness:Number=1, fillColor:uint=0, fillAlpha:Number=0, 
										caps:String=null, joints:String=null, miter:Number=4, close:Boolean=false):String
		{
			if (pts.length > 1)
			{
				var line:String = '';
				var p:Point = pts.shift();
				line = '<path d="M ' + p.x + ' ' + p.y + ' L ';
				var all:Array = [];
				for each (var pt:Point in pts)
				{
					all.push(pt.x);
					all.push(pt.y);
				}
				
				var style:String = SVGConstants.getStyleString(thickness, strokeColor, strokeAlpha, fillColor, fillAlpha, caps, joints, miter);
				
				var pathSuffix:String = (close) ? ' z" ' : '" ';
				line = line + all.join(' ') + pathSuffix + style + '/>';
				return line;
			}
			
			return '';
		}
		
		public static function drawClosedLine(pts:Array, strokeColor:uint, strokeAlpha:Number=1, thickness:Number=1, fillColor:uint=0, fillAlpha:Number=0, 
										caps:String=null, joints:String=null, miter:Number=4):String
		{
			if (pts.length > 1)
			{
				var line:String = '';
				var p:Point = pts.shift();
				line = '<path d="M ' + p.x + ' ' + p.y + ' L ';
				var all:Array = [];
				for each (var pt:Point in pts)
				{
					all.push(pt.x);
					all.push(pt.y);
				}
				
				var style:String = SVGConstants.getStyleString(thickness, strokeColor, strokeAlpha, fillColor, fillAlpha, caps, joints, miter);
				
				line = line + all.join(' ') + ' z" ' + style + '/>';
				return line;
			}
			
			return '';
		}
		
		public static function drawPolyline(line:Polyline, map:Map):String
		{
			if (line.locationsArray.length > 1)
			{
				var l:Location = line.locationsArray[0];
				var p:Point = map.localToGlobal(map.locationPoint(l, map));
				var pathStr:String = '<path d="M ' + p.x + ' ' + p.y + ' L ';
				
				var pts:Array = [];
				for each (var loc:Location in line.locationsArray)
				{
					p = map.localToGlobal(map.locationPoint(loc, map));
					pts.push(p.x);
					pts.push(p.y);
				}
				
				var styleStr:String = SVGConstants.getStyleString(	line.lineThickness, line.lineColor, 
																	line.lineAlpha, 0, 0, line.caps,
																	line.joints, line.miterLimit);
				pathStr = pathStr + pts.join(' ') + '" ' + styleStr + '/>';
				return pathStr;
			}	
			return '';
		}
	}
}