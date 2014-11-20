package com.shashi.model
{
		
	public class NumberFormat
	{
		public function NumberFormat()
		{
		}
			
		public static function stripCommas(str:String):int
		{
			var pat:RegExp = /[$,\"-]/g;
			return parseInt(str.replace(pat,''));
		}
		
		// lame
		public static function addCommas(num:int):String
		{
			if (num < 1000)
				return num.toString();			
			else if (num < 1000000)
				return int(num / 1000).toString() + ',' + NumberFormat.addZeros(num % 1000);
			else 
				return int(num / 1000000).toString() + ',' + NumberFormat.addZeros((num % 1000000) / 1000) + ',' + NumberFormat.addZeros((num % 1000000) % 1000);
		}
		
		public static function addZeros(val:int):String
		{
			var num:String = int(val).toString();
			while (num.length < 3)
			{
				num = '0' + num;
			}
			
			return num;
		}
	}
}