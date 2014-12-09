package com.cup.model {
	import flash.display.BitmapData;
	
	public interface IPDFGenerator {
		function testBitmap(bitty:BitmapData):void;
		
		function outputPDF(incomes:Array, bitty:BitmapData):void;
	}
}