package com.cup.model
{
	public class ColorsCUP
	{
		public static const YELLOW:uint = 0xF49B18; // 0xFFD400;
		public static const RED:uint = 0xED1C24;
		public static const BROWN:uint = 0x5E0F0C;
		public static const BLUE:uint = 0x2B338C;
		public static const GREEN:uint = 0xC8040;
		public static const PINK:uint = 0xD54799;
		
		public static const LIGHTBLUE:uint = 0x2e89c8;
		
		public static const INCOME_LEVELS:Array = ['', 'Extremely Low Income', 'Very Low Income', 'Low Income', 'Moderate Income', 'Middle Income', 'High Income'];
		 
		public function ColorsCUP()
		{
		}
		
		public static function getColor(incomeLevel:String):uint
		{
			switch (incomeLevel.toLowerCase())
			{
				case 'extremely low income':
					return YELLOW;
				case 'very low income':
					return RED;
				case 'low income':	
					return BROWN;
				case 'moderate income':	
					return BLUE;
				case 'middle income':
					return GREEN;
				case 'high income':
					return PINK;
				default:
					return 0x000000;
			}
		}
	}
}