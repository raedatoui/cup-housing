package com.shashi.display
{
	import flash.display.Sprite;

	public class RoundRect extends Sprite
	{
		public var radius:Number = 0;
		public var color:uint = 0xFFFFFF;
		
		protected var _alpha:Number = 1;
		protected var _width:Number = 0;
		protected var _height:Number = 0;
		
		public function RoundRect(radius:Number=0, w:Number=0, h:Number=0, color:uint = 0xFFFFFF, alpha:Number=1)
		{
			super();
			
			this.color = color;
			this.radius = radius;
			
			this.width = w;
			this.height = h;
			_alpha = alpha;
			
			draw(w, h);
		}
		
		public function setColor(col:uint):void
		{
			color = col;
			draw(_width, _height);
		}
		
		public function draw(w:Number=0, h:Number=0, stroke:int=0):void
		{
			with (this.graphics)
			{
				graphics.clear();
				if (stroke > 0)	lineStyle(2, 0x000000);
				beginFill(color, _alpha);
				drawRoundRect(-w/2, -h/2, w, h, radius);
			}
		}
		
		override public function set alpha(value:Number):void
		{
			if (_alpha != value)
				_alpha = value;
		}
		
		override public function get alpha():Number
		{
			return _alpha;
		}
		
		override public function set width(value:Number):void
		{
			if (_width != value)
				draw(value, _height);
				
			_width = value;
		}
		
		override public function get width():Number
		{
			return _width;
		}
		
		override public function set height(value:Number):void
		{
			if (_height != value)
				draw(_width, value);
				
			_height = value;
		}
		
		override public function get height():Number
		{
			return _height;
		}
	}
}