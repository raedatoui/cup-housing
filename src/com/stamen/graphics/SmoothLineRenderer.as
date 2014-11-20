package com.stamen.graphics
{
	import flash.display.Graphics;
	import com.stamen.geom.*;
	import flash.geom.Point;
	
	public class SmoothLineRenderer
	{
		public var curvature:Number;

		public static function cubicBezier(t:Number, b:Number, c:Number, d:Number, p1:Number, p2:Number):Number
        {   
            return ((t /= d) * t * c + 3 * (1 - t) * (t * (p2 - b) + (1 - t) * (p1 - b))) * t + b;
        }
        
        public static function drawBezierCurve(graphics:Graphics, start:Point, control1:Point, end:Point, control2:Point, steps:uint=50):void
        {
        	if (!steps)
			{
				throw new Error('You must provide a number of steps');
			}
			var dx:Number = end.x - start.x;
			var dy:Number = end.y - start.y;
			// graphics.moveTo(start.x, start.y);
			for (var t:uint = 0; t < steps; t++)
			{
				var x:Number = cubicBezier(t, start.x, dx, steps, control1.x, control2.x);
				var y:Number = cubicBezier(t, start.y, dy, steps, control1.y, control2.y);
				graphics.lineTo(x, y);
			}
        }
        
		public function SmoothLineRenderer(curvature:Number=.65)
		{
			super();
			this.curvature = curvature;
		}
		
		public function render(points:Array, graphics:Graphics):void
		{
			if (!points || points.length == 0)
			{
				throw new Error('No points provided!');
			}
			else if (!graphics)
			{
				throw new Error('No graphics instance provided!');
			}
			
			var lines:Array = new Array();
			var len:uint = points.length;
			var i:uint, center:Point, previous:Point, next:Point;
			for (i = 0; i < len; i++)
			{
				center = points[i] as Point;
				if (!center) continue;

				previous = points[(len + i - 1) % len] as Point;
				next = points[(len + i + 1) % len] as Point;
				var referenceLine:Line = new Line(previous, next);
				
				referenceLine.length *= 1 - curvature;
				var slope:Point = referenceLine.slope;
				
				var line:Line = new Line(center, center);
				line.start.x -= slope.x / 2;
				line.start.y -= slope.y / 2;
				line.end.x += slope.x / 2;
				line.end.y += slope.y / 2;
				lines.push(line);
				
				//graphics.lineStyle(0, 0xFFFFFF, .25);
				//line.draw(graphics);
				//graphics.drawCircle(center.x, center.y, 5);
				//graphics.lineStyle();
			}
			
			for (i = 0; i < len; i++)
			{
				center = points[i] as Point;
				previous = points[(len + i - 1) % len] as Point;
				
				var line1:Line = lines[(len + i - 1) % len] as Line;
				var line2:Line = lines[(len + i) % len] as Line;
				
				drawBezierCurve(graphics, previous, line1.end, center, line2.start);
				graphics.lineTo(center.x, center.y);
			}
		}
	}
}