package com.cup.ui
{
	import com.shashi.display.HoverLabel;
	
	import flash.filters.DropShadowFilter;
	import flash.text.AntiAliasType;

	public class CUPHoverLabel extends HoverLabel
	{
		public function CUPHoverLabel(radius:Number=0, w:Number=0, h:Number=0, textColor:uint=0x000000, bgColor:uint=0xDDDDDD, bold:Boolean=true, fontSize:int=11)
		{
			super(radius, w, h, textColor, bgColor, bold, fontSize);
			
			detail.antiAliasType = AntiAliasType.ADVANCED;
			subhead.antiAliasType = AntiAliasType.ADVANCED;
			
			filters = [ new DropShadowFilter(1,45,0,1,3,3,.7,2) ];
		}
	}
}