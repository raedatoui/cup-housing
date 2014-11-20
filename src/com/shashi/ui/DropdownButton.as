package com.shashi.ui
{
	import com.shashi.model.TextMaker;
	import com.stamen.ui.tooltip.TooltipBlocker;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.AntiAliasType;
	import flash.text.TextField;

	public class DropdownButton extends Sprite implements IButton, TooltipBlocker
	{
		public static const ADDED:String = 'added';
		
		protected var label:TextField;
		protected var rightButton:UIButton;
		
		protected var padding:Number = 3;
		
		protected var _w:Number;
		protected var _h:Number;
		protected var _bgCol:uint;
		protected var _pressed:Boolean = false;
		
		public function DropdownButton(text:String, rightType:String, width:Number=100, size:Number=14, textColor:uint=0xFFFFFF, bold:Boolean=true, bgColor:uint=0x000000)
		{
			super();
			
			label = TextMaker.createTextField(size, bold, textColor);
			label.antiAliasType = AntiAliasType.ADVANCED;
			label.text = text;
			label.x = padding;
			label.multiline = label.wordWrap = false;
			addChild(label);
			
			_w = (width) ? width : label.textWidth + 4 + padding * 2;
			_h = label.height;
			
			if (rightType.length)
			{
				addRightType(rightType);
			}
			
			if (bgColor)
			{
				_bgCol = bgColor;
			}
			
			draw(bgColor, 1);
			
			buttonMode = useHandCursor = true;
			
			addEventListener(MouseEvent.MOUSE_OVER, onOver);
			addEventListener(MouseEvent.MOUSE_OUT, onOut);
			addEventListener(MouseEvent.CLICK, onClick);
		}
		
		protected function draw(bgColor:uint=0x000000, bgAlpha:Number=0):void
		{
			graphics.clear();
			graphics.beginFill(bgColor, bgAlpha);
			graphics.drawRect(0, 0, _w, _h); 
			graphics.endFill();
			
			if (rightButton)
			{
				rightButton.x = _w - rightButton.width/2 - padding;
				rightButton.y = _h/2;
			}
		}
		
		public function addRightType(type:String):void
		{
			if (type.length == 0 || rightButton)	return;
			
			rightButton = new UIButton(type);
			
			if (type == UIButton.ADD)
			{
				rightButton.addEventListener(MouseEvent.CLICK, onAdded);
				rightButton.pressed = false;
			}
			
			addChild(rightButton);
			
			draw(0xFFFFFF, .2);
		}
		
		public function set pressed(value:Boolean):void
		{
			_pressed = value;
			
			if (_pressed)
				draw(0xFFFFFF, .4);
			else
				onOut();
		}
		
		public function get pressed():Boolean
		{
			return _pressed;
		}
		
		public function set added(value:Boolean):void
		{
			if (rightButton) rightButton.pressed = value;
		}
		
		public function get added():Boolean
		{
			return (rightButton) ? rightButton.pressed : false;
		}
		
		public function set text(value:String):void
		{
			label.text = value;
		}
		
		public function get text():String
		{
			return label.text;
		}
		
		override public function get width():Number
		{
			return _w;
		}
		
		override public function get height():Number
		{
			return _h;
		}
		
		public function onClick(event:MouseEvent=null):void
		{
		}
		
		public function onAdded(event:MouseEvent=null):void
		{
			dispatchEvent(new Event(DropdownButton.ADDED));
		}
		
		public function onOver(event:MouseEvent=null):void
		{
			draw(0xFFFFFF, .2);
		}
		
		public function onOut(event:MouseEvent=null):void
		{			
			if (_pressed)
				draw(0xFFFFFF, .4);
			else
				draw(_bgCol, (_bgCol) ? 1 : 0);
		}
		
	}
}