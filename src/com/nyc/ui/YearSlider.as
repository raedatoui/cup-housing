package com.nyc.ui
{
	import com.shashi.ui.Slider;
	import com.stamen.graphics.color.IColor;
	import com.stamen.ui.tooltip.TooltipProvider;
	
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;

	public class YearSlider extends Slider implements TooltipProvider
	{
		public var maxYears:int;
				
		public function YearSlider(w:Number=0, h:Number=0, barColor:IColor=null, slideColor:IColor=null)
		{
			super(w, h, barColor, slideColor);
			
			bar.filters = [new GlowFilter(0x000000, .5, 2, 2, 2)];
			slide.filters = [new DropShadowFilter(1,45,0,1,3,3,.7,2)];
			
			position = 1;
		}
		
		public function getTooltipText():String
		{
			return 'Show ridership in ' + (int(getCurrentValue() * maxYears) + 1905).toString();
		}
	}
}