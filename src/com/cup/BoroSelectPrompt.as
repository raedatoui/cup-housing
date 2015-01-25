package com.cup
{
	import com.shashi.ui.DropdownButton;
	
	import flash.events.MouseEvent;
	
	public class BoroSelectPrompt extends DropdownButton
	{
		public function BoroSelectPrompt(text:String, rightType:String, width:Number=100, size:Number=14, textColor:uint=0xFFFFFF, bold:Boolean=true, bgColor:uint=0x000000)
		{
			super(text, rightType, width, size, textColor, bold, bgColor);
		}
		override public function onOver(event:MouseEvent = null):void {
			draw(this._bgCol, .2);
			this.label.textColor = 0x000000;
		}
		override public function onOut(event:MouseEvent = null):void {
			super.onOut(event);
			this.label.textColor = 0xFFFFFF;			
		}
	}
}