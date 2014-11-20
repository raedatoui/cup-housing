package com.shashi.ui
{
	import com.shashi.display.DragRect;
	import com.shashi.events.SliderEvent;
	import com.stamen.graphics.color.IColor;
	import com.stamen.ui.BlockSprite;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import gs.TweenLite;

	public class Slider extends BlockSprite
	{
		protected var bar:DragRect;
		protected var slide:BlockSprite;
		protected var _dragging:Boolean = false; 
		protected var _position:Number = 0; 
		protected var _playhead:Number = 0;
		protected var _barWidth:Number = 0;
		
		public function Slider(w:Number=0, h:Number=0, barColor:IColor=null, slideColor:IColor=null)
		{
			super(w, h, slideColor);
			
			_barWidth = (_barWidth > 0) ? _barWidth : h;
			
			slide = new BlockSprite(w, h, slideColor);
			slide.useHandCursor = true;
			slide.buttonMode = true;
			slide.graphics.lineStyle(1, 0xFFFFFF);
			slide.graphics.beginFill(slideColor.hex, slideColor.alpha);
			slide.graphics.drawRect(-.5, -.5, w+1, h+1);
			addChild(slide);
			
			bar = new DragRect(_barWidth, h + .5, barColor.hex);
			bar.mouseEnabled = false;
			bar.x = 0;
			bar.y = -.5;
			addChild(bar);
			
			slide.addEventListener(MouseEvent.MOUSE_DOWN, onDown);
		}
		
		public function get dragging():Boolean
		{
			return _dragging;
		} 
		
		public function set position(value:Number):void
		{
			value = Math.max(0, Math.min(1, value));
			if (_position != value)
			{
				_position = value;
				bar.x = Math.max(0, Math.min(this.width - bar.width, value * (this.width - bar.width)));
				
				// the position has changed
				dispatchEvent(new Event(Event.CHANGE));
			}
		}
		
		// _position is 0 to 1
		public function get position():Number
		{
			return _position;
		}
		
		public function set playhead(value:Number):void
		{
			if (_playhead != value)
			{
				_playhead = value;
				
				dispatchEvent(new Event(Event.CHANGE));
			}
		}
		
		public function get playhead():Number
		{
			return _playhead;
		}
		
		protected function onPositionFinished():void
		{
			dispatchEvent(new SliderEvent(SliderEvent.STOPPED));
		}
		
		protected function onDown(event:MouseEvent):void
		{
			stage.addEventListener(MouseEvent.MOUSE_UP, cancelDrag);
			stage.addEventListener(Event.MOUSE_LEAVE, cancelDrag);
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onDrag);
			
			_dragging = true;
			
			var cur:Number = Math.max(0, Math.min(1, getCurrentValue()));
			clickedOnPosition(cur);
		}
		
		protected function clickedOnPosition(cur:Number):void
		{
			if (position != cur)
			{
				var dist:Number = Math.abs(position - cur);
				
				// this pauses buffering elsewhere
				dispatchEvent(new SliderEvent(SliderEvent.PLAYING));
				
				if (dist > .05)
					TweenLite.to(this, dist * 10, {position:cur, onComplete:onPositionFinished});
				else
					position = cur;
			}			
		}
		
		protected var lastMouse:Number = 0;
		protected function onDrag(event:Event):void
		{
			if (_dragging)
			{
				// set the bar
				TweenLite.killTweensOf(this);
				position = getCurrentValue();				
			}
		}
		
		protected function getCurrentValue():Number
		{
			return this.mouseX / slide.width;
		}
		
		protected function cancelDrag(event:Event=null):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onDrag);
			stage.removeEventListener(MouseEvent.MOUSE_UP, cancelDrag);
			stage.removeEventListener(Event.MOUSE_LEAVE, cancelDrag);
			_dragging = false;
			
			dispatchEvent(new SliderEvent(SliderEvent.STOPPED));
		}
	}
}