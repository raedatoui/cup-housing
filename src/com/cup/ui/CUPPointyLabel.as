package com.cup.ui
{
	public class CUPPointyLabel extends CUPHoverLabel
	{
		public function CUPPointyLabel(radius:Number=0, w:Number=0, h:Number=0, textColor:uint=0x000000, bgColor:uint=0xDDDDDD, bold:Boolean=true, fontSize:int=11)
		{
			super(radius, w, h, textColor, bgColor, bold, fontSize);
		}
		
		override public function draw(w:Number=0, h:Number=0, stroke:int=0):void
		{
			with (this.graphics)
			{
				graphics.clear();
				if (stroke > 0)	lineStyle(2, 0x000000);
				beginFill(color, _alpha);
				drawRoundRect(-w/2, -h/2, w, h, radius);
				moveTo(-h/4, h/2);
				lineTo(h/4, h/2);
				lineTo(0, h/2 + (h/4));
				endFill();
			}
		}
		
	}
}