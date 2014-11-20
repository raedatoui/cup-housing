package com.cup.model
{
	public class MoneyStr
	{
		public function MoneyStr()
		{
		}
		
		public static function to$$K(value:Number):String
		{
			return int(value / 1000).toString() + 'K';
		}
		
		public static function toDollarThousands(value:Number):String
		{
			var thou:String = value >= 1000 ? int(value / 1000).toString() + ',' : '';
			  
			return '$' + thou + int((value % 1000) / 100).toString() + '00';
		}
		
		public static function to$Thousands(value:int):String
		{
			var thou:String = value >= 1000 ? int(value / 1000).toString() + ',' : '';
			
			return '$' + thou + fillDigits(value % 1000); 
		}
		
		public static function to$050s(value:int):String
		{
			var thou:String = value >= 1000 ? int(value / 1000).toString() + ',' : '';
			
			return '$' + thou + fillDigits(Math.round((value % 1000) / 50) * 50);
		}
		
		public static function fillDigits(value:Number, digits:int=3):String
		{
			var str:String = value.toString();
			
			while (str.length < digits)
			{
				str = '0' + str;
			}
			
			return str;
		}
	}
}