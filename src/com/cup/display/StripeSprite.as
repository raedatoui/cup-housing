package com.cup.display
{
	import com.cup.model.ColorsCUP;
	import com.stamen.graphics.color.IColor;
	import com.stamen.ui.BlockSprite;
	
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.utils.setInterval;

	public class StripeSprite extends BlockSprite
	{
		public function StripeSprite(w:Number=0, h:Number=0, color:IColor=null)
		{
			bitmap = new BitmapData(5, 5, false, 0x000000);
			
			bitmap.setPixel(0, 0, ColorsCUP.PINK);
			bitmap.setPixel(1, 0, ColorsCUP.PINK);
			bitmap.setPixel(1, 1, ColorsCUP.PINK);
			bitmap.setPixel(2, 1, ColorsCUP.PINK);
			bitmap.setPixel(2, 2, ColorsCUP.PINK);
			bitmap.setPixel(3, 2, ColorsCUP.PINK);
			bitmap.setPixel(3, 3, ColorsCUP.PINK);
			bitmap.setPixel(4, 3, ColorsCUP.PINK);
			bitmap.setPixel(4, 4, ColorsCUP.PINK);
			bitmap.setPixel(0, 4, ColorsCUP.PINK);
//			for (var i:int=0; i<4; i++)
//			{
//				bitmap.setPixel(i, i, ColorsCUP.PINK);
//			}
			
			super(w, h, color);
		}
		
		
		public function startScroll():void
		{
			visible = true;
			// addEventListener(Event.ENTER_FRAME, onFrame);
			setInterval(onFrame, 500);
		}
		
		public function endScroll():void
		{
			visible = false;
			removeEventListener(Event.ENTER_FRAME, onFrame);
			
		}
		
		protected var flip:Boolean = true;
		protected function onFrame(event:Event=null):void
		{
			alpha += (flip) ? .05 : -.05;
			
			if (alpha > 1 || alpha < 0)
				flip = !flip;
		}
		
		override protected function draw(color:IColor=null):void
		{
			super.draw(color);
		}
	}
}