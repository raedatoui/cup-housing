package com.shashi.ui
{
	import com.shashi.model.TextMaker;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.text.TextField;

	public class TextfieldToggle extends Sprite
	{
		protected var text:TextField;
		protected var op1:String;
		protected var op2:String;
		protected var isFirst:Boolean = true;
		
		public function TextfieldToggle(option1:String, option2:String, size:int, color:uint, firstIsDefault:Boolean=true)
		{
			super();
			
			op1 = option1;
			op2 = option2;
			
			isFirst = firstIsDefault;
			
			text = TextMaker.createTextField(size, false, color);
			text.htmlText = (firstIsDefault) ? ("<b>" + option1 + "</b> / " + option2) : (option1 + " / <b>" + option2 + "</b>");
			addChild(text);
			
			this.useHandCursor = this.buttonMode = true;
			addEventListener(MouseEvent.MOUSE_OVER, onOver);
			addEventListener(MouseEvent.MOUSE_OUT, onOut);
			addEventListener(MouseEvent.CLICK, toggle);
		}
		
		public function get isFirstSelected():Boolean
		{
			return isFirst;
		}
		
		public function set isFirstSelected(val:Boolean):void
		{
			isFirst = val;
			
			retext();
		}
		
		protected function onOver(event:Event):void
		{
			this.filters = [new DropShadowFilter(1,45,0xffffff,1,3,3,.7,2)];
		}
		
		protected function onOut(event:Event):void
		{
			this.filters = [];
		}
		
		protected function toggle(event:Event):void
		{
			isFirst = !isFirst;
			retext();
		}
		
		protected function retext():void
		{
			text.htmlText = (isFirst) ? ("<b>" + op1 + "</b> / " + op2) : (op1 + " / <b>" + op2 + "</b>");
		}
	}
}