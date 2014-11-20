package com.cup.display
{
	import com.cup.model.MoneyStr;
	import com.stamen.ui.tooltip.TooltipProvider;
	
	import flash.display.Sprite;

	public class ChartDot extends Sprite implements TooltipProvider
	{
		protected var tooltip:String;
		
		public function ChartDot(col:uint, median:String, income:int)
		{
			var size:int = 3.5;
			
			super();
			this.graphics.beginFill(col);
			this.graphics.lineStyle(2, 0xFFFFFF);
			this.graphics.drawRect(-size, -size, size*2, size*2);
			
			this.rotation = 45;
			this.useHandCursor = this.buttonMode = true;
			tooltip = median + ' income for NYC is ' + MoneyStr.to$$K(income);
		}
		
		public function getTooltipText():String
		{
			return tooltip;
		}
		
	}
}