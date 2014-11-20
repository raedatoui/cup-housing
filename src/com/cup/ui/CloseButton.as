package com.cup.ui
{
	import flash.display.CapsStyle;
	import flash.display.JointStyle;
	import flash.display.LineScaleMode;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class CloseButton extends Sprite
	{
		protected var size:int = 16;
		
		public function CloseButton()
		{
			super();
			
			onOut();
			
			addEventListener(MouseEvent.MOUSE_OVER, onOver);
			addEventListener(MouseEvent.MOUSE_OUT, onOut);
			
			useHandCursor = buttonMode = true;
		}
		
		protected function onOver(event:MouseEvent):void
		{
			graphics.clear();
			graphics.lineStyle(3, 0xFFFFFF, 1, false, LineScaleMode.NONE, CapsStyle.SQUARE, JointStyle.BEVEL);
			graphics.beginFill(0);
			graphics.drawRect(0, 0, size, size);
			graphics.lineStyle(2, 0xFFFFFF, 1, false, LineScaleMode.NONE, CapsStyle.SQUARE, JointStyle.BEVEL);
			graphics.moveTo(0, 0);
			graphics.lineTo(size, size);
			graphics.moveTo(size, 0);
			graphics.lineTo(0, size);
			graphics.endFill();
			graphics.lineStyle();			
		}
		
		protected function onOut(event:MouseEvent=null):void
		{
			graphics.clear();
			graphics.lineStyle(3, 0xFFFFFF, 1, false, LineScaleMode.NONE, CapsStyle.SQUARE, JointStyle.BEVEL);
			graphics.beginFill(0);
			graphics.drawRect(0, 0, size, size);
			graphics.endFill();
			graphics.lineStyle();
		}
		
	}
}