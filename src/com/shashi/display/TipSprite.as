package com.shashi.display
{
	import com.stamen.graphics.color.IColor;
	import com.stamen.ui.BlockSprite;
	import com.stamen.ui.tooltip.TooltipProvider;

	public class TipSprite extends BlockSprite implements TooltipProvider
	{
		public function TipSprite(w:Number=0, h:Number=0, color:IColor=null)
		{
			super(w, h, color);
		}
		
		protected var tip:String = '';
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