package com.cup.model {
	import com.shashi.model.NumberFormat;
	
	public class SubBoroIncomes {
		public var name:String;
		public var borough:String;
		public var id:String;
		public var incomeLevels:Array;
		
		public var estimatedRent:int = -1;
		
		public var familyCount:int;
		public var medianIncome:int;
		
		public function SubBoroIncomes() {
		}
		
		public static function fromTxt(txt:String):SubBoroIncomes {
			var values:Array = txt.split(',');
			trace(values.length);
			
			if (values.length >= 10) {
				var sub:SubBoroIncomes = new SubBoroIncomes();
				sub.id = values[0].toString();
				sub.borough = values[1].toString();
				sub.name = values[2].toString();
				
				sub.incomeLevels = [];
				for (var i:int = 3; i < 9; i++) {
					sub.incomeLevels.push(NumberFormat.stripCommas(values[i]));
				}
				
				sub.medianIncome = NumberFormat.stripCommas(values[10]);
				
				return sub;
			}
			else {
				return null;
			}
		}
	}
}