package com.cup.display
{
	import com.stamen.graphics.color.IColor;
	import com.stamen.ui.BlockSprite;

	public class PopBlock extends BlockSprite
	{
		protected var stroke:int = 0;
		protected var strokeColor:uint = 0xFFFFFF;
		protected var strokeAlpha:Number = 1;
		protected var tip:String = '';
		
		public function PopBlock(w:Number=0, h:Number=0, color:IColor=null)
		{
			super(w, h, color);
		}
		
		public function set blockColor(color:IColor):void
		{
			draw(color);
		}
		
		override protected function draw(color:IColor=null):void
		{
			if (!color) color = _color;
			
			var round:Number = roundedness;
			with (graphics)
			{
				clear();
				
				if (color || bitmap)
				{
					if (stroke)
					{
						lineStyle(stroke, strokeColor, strokeAlpha);
					}
					
				    if (bitmap)
				    {
				        beginBitmapFill(bitmap);
				    }
				    else
				    {
                        beginFill(color.toHex(), color.alpha);
				    }
					if (!isNaN(round) && round > 0)
					{
						drawRoundRect(0, 0, width, height, round, round);
					}
					else
					{
						drawRect(0, 0, width, height);
					}
    				endFill();
    				
    				if (stroke)
    				{
    					lineStyle();
    				}
				}
			}
		}
		
		public function setTooltipText(value:String):void
		{
			tip = value;
		}
		
		public function getTooltipText():String
		{
			return tip;
		}
		
	}
}