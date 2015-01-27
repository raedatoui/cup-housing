package com.cup.output {
	
	import com.cup.model.SubBoroIncomes;
	import com.cup.output.PDFCompositor;
	import com.fonts.ConduitBold;
	import com.fonts.ConduitMedium;
	
	import flash.display.BitmapData;
	import flash.text.Font;
	
	public class MainPrinter {
		public var incomeData:Array = [];
		public var regularFont:Font = new ConduitMedium();
		public var boldFont:Font = new ConduitBold();
		public var testData:BitmapData = new BitmapData(50, 50, false, 0xff0000);

		protected var shapeURL:String;
		protected var printURL:String;
		protected var chartColors:Array;
		protected var incomeDescriptions:Array;
		protected var incomeRanges:Array;
		
		public function MainPrinter(incomes:Array, printURL:String, shapeURL:String, colors:Array, descriptions:Array, ranges:Array) {
			this.incomeData = incomes;
			this.shapeURL = shapeURL;
			this.printURL = printURL;
			this.chartColors = colors;
			this.incomeDescriptions = descriptions;
			this.incomeRanges = ranges;
		}
			
		public function printSinglePDF(id:String, rent:int, strip1:BitmapData, strip2:BitmapData):void {
			var selectBoroughs:Array = new Array;
			var squareValue:int = 1000;
			
			switch (id) {
				case "100":
					selectBoroughs = ["101", "102", "103", "104", "105", "106", "107", "108", "109", "110"];
					break;
				case "200":
					selectBoroughs = ["201", "202", "203", "204", "205", "206", "207", "208", "209", "210", "211", "212", "213", "214", "215", "216", "217", "218"];
					break;
				case "300":
					selectBoroughs = ["301", "302", "303", "304", "305", "306", "307", "308", "309", "310"];
					break;
				case "400":
					selectBoroughs = ["401", "402", "403", "404", "405", "406", "407", "408", "409", "410", "411", "412", "413", "414"];
					break;
				case "500":
					selectBoroughs = ["501", "502", "503"];
					break;
				
				default:
					selectBoroughs = [id];
					squareValue = 100;
					break;
				
			}
			
			for each (var income:SubBoroIncomes in incomeData) {
				if (id == income.id) {
					trace('found id:', id, income);
					outputPDF([income], selectBoroughs, rent, strip1, strip2, squareValue);
					return;
				}
			}
		}
		
		public function outputPDF(incomes:Array, boroughs:Array, rent:int, strip1:BitmapData, strip2:BitmapData, squareVal:int):void {
			var testPDF:PDFCompositor = new PDFCompositor(printURL, shapeURL, squareVal, regularFont, boldFont, chartColors, incomeDescriptions, incomeRanges);
			testPDF.print(incomes, boroughs, strip1, rent, false);
		}
	}
}