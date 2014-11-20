package com.nyc.ui
{
	import com.modestmaps.extras.ui.Button;
	
	import flash.events.MouseEvent;

	public class NYCButton extends Button
	{
		public function NYCButton(type:String=null, innerColor:uint=0xFFFFFF, outerColor:uint=0x666666)
		{
	        useHandCursor = true;
	        buttonMode = true;
	        cacheAsBitmap = true;
	        
	        addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
	        addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
	        
	        drawShape(outerColor);
	        drawButton(innerColor, type);
	        
	        transform.colorTransform = outTransform;		
		}
		
		override protected function drawButton(color:uint=0xFFFFFF, type:String=null):void
		{
			super.drawButton(color, type);
		}
		
		override protected function drawShape(color:uint=0x000000):void
		{
	        graphics.clear();
	        graphics.beginFill(color);
	        graphics.drawCircle(10, 10, 10);
	        /* graphics.drawRoundRect(0, 0, 20, 20, 9, 9);
	        graphics.beginFill(0xffffff);
	        graphics.drawRoundRect(0, 0, 18, 18, 9, 9);
	        graphics.beginFill(0xbbbbbb);
	        graphics.drawRoundRect(2, 2, 18, 18, 9, 9);
	        graphics.beginFill(0xdddddd);
	        graphics.drawRoundRect(1, 1, 18, 18, 9, 9); */
		}
	}
}