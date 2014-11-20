package com.stamen.geom
{
	import com.stamen.utils.MathUtils;
	
	import flash.display.*;
	import flash.geom.Point;

	public class Line
	{
		protected var _start:Point;
		protected var _end:Point;
		
		public static function between(a:DisplayObject, b:DisplayObject, context:DisplayObject=null):Line
		{
			var start:Point = new Point(a.x, a.y);
			var end:Point = new Point(b.x, b.y); 
			if (context)
			{
				start = a.parent.localToGlobal(start);
				end = b.parent.localToGlobal(end);
			}
			var line:Line = new Line(start, end);
			return context
				   ? line.localize(context)
				   : line;			
		}

		public function Line(start:Point=null, end:Point=null)
		{
			_start = start ? start.clone() : new Point();
			_end = end ? end.clone() : new Point();
		}
		
		public function flip():Line
		{
			return new Line(_end, _start);
		}

		public function clone():Line
		{
			return new Line(_start, _end);
		}
		
		public function get start():Point
		{
			return _start;
		}
		
		public function set start(p:Point):void
		{
			_start = p.clone();
		}
		
		public function get end():Point
		{
			return _end;
		}
		
		public function set end(p:Point):void
		{
			_end = p.clone();
		}
		
		public function get center():Point
		{
			return pointAt(.5);
		}
		
		public function set center(p:Point):void
		{
			var oldCenter:Point = center;
			var delta:Point = p.subtract(oldCenter);
			translate(delta);
		}
		
		public function pointAt(f:Number):Point
		{
			return Point.interpolate(_start, _end, f);
		}
		
		public function stretch(len:Number):Line
		{
			var c:Point = center;
			var line:Line = clone();
			line.length = len;
			line.center = c;
			return line;
		}

		public function translate(p:Point):void
		{
			_start = _start.add(p);
			_end = _end.add(p);
		}
		
		public function get length():Number
		{
			return Point.distance(_start, _end);
		}
		
		public function set length(len:Number):void
		{
			_end = Point.interpolate(_start, _end, len / length);
		}
		
		public function get degrees():Number
		{
			return MathUtils.degrees(radians);
		}
		
		public function set degrees(d:Number):void
		{
			radians = MathUtils.radians(d);
		}
		
		public function get radians():Number
		{
			return Math.atan2(dy, dx);
		}
		
		public function set radians(rad:Number):void
		{
			_end = Point.polar(length, rad);
		}
		
		public function get dx():Number
		{
			return _end.x - _start.x;
		}
		
		public function set dx(x:Number):void
		{
			_end.x = _start.x + x;
		}
		
		public function get dy():Number
		{
			return _end.y - _start.y;
		}
		
		public function set dy(y:Number):void
		{
			_end.y = _start.y + y;
		}
		
		public function get slope():Point
		{
			return _end.subtract(_start);
		}
		
		public function set slope(p:Point):void
		{
			_end = _start.add(p);
		}
		
		public function perp(v:Point):Number
		{
			return (dx * v.y) - (dy * v.x);
		}

		/**
		 * Get the point at which two lines intersect. If strict is true
		 * and they don't, a LineIntersectionError is thrown, and you can use
		 * the error's "t" member to determine which side of the line the
		 * intersection would have occurred. Otherwise, a point along the
		 * imaginary extension of the primary line is returned.
		 */
		public function intersect(line:Line, strict:Boolean=false):Point
		{
			if (slope.equals(line.slope))
			{
				if (strict)
				{
					throw new LineIntersectionError('Lines are parallel', Number.POSITIVE_INFINITY);
				}
				return null;
			}

			var s:Point = line.slope;
			var v3:Line = new Line(new Point(0, 0), line.start.subtract(_start));
			var t:Number = v3.perp(s) / perp(s);
			
			if (strict && (t < 0 || t > 1))
			{
				throw new LineIntersectionError('Lines do not intersect directly (t = ' + t + ')', t);
			}

			var d:Point = new Point(dx * t, dy * t);
			return _start.add(d);
		}

		public function contextualize(fromContext:DisplayObject, toContext:DisplayObject):Line
		{
			var start:Point = PointUtils.contextualize(_start, fromContext, toContext);
			var end:Point = PointUtils.contextualize(_end, fromContext, toContext);
			return new Line(start, end);
		}

		public function localize(context:DisplayObject):Line
		{
			return new Line(context.globalToLocal(_start),
							context.globalToLocal(_end));
		}
		
		public function globalize(context:DisplayObject):Line
		{
			return new Line(context.localToGlobal(_start),
							context.localToGlobal(_end));
		}
		
		public function draw(g:Graphics, moveToStart:Boolean=true, drawPoints:Boolean=false):void
		{
			if (drawPoints) g.drawCircle(_start.x, _start.y, 3);
			g.moveTo(_start.x, _start.y);
			g.lineTo(_end.x, _end.y);
			g.moveTo(_start.x, _start.y);
			if (drawPoints) g.drawCircle(_end.x, _end.y, 5);
		}
	}
}