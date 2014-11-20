package com.stamen.logic.tests
{
	import asunit.framework.TestCase;
	
	import com.stamen.logic.*;
	
	import flash.utils.Dictionary;

	public class LogicTestCase extends TestCase
	{
	
		private var data:Array;
		
		override protected function setUp():void
		{
			if (data) return;
			
			data = [ ];
			//var counts:Object = { 1950: 0, 1990: 0, 1980: 0, 2000: 0 };
			var obj:Object;
			var i:int;
			for (i = 0; i < 1000; i++) {
				obj = { id: i, 
					    propertyType: 'Town', 
					    yearBuilt: i < 500 ? 1950 : 1990,
					    random: Math.random() };
				//counts[obj.yearBuilt] = counts[obj.yearBuilt] + 1; 
				data.push(obj);
			}			
			for (i = 1000; i < 2500; i++) {
				obj = { id: i, 
					    propertyType: 'Family', 
					    yearBuilt: i < 1500 ? 1950 : 1980,
					    random: Math.random() };
				//counts[obj.yearBuilt] = counts[obj.yearBuilt] + 1; 
				data.push(obj);
			}			
			for (i = 2500; i < 5000; i++) {
				obj = { id: i, 
					    propertyType: 'Apartment', 
					    yearBuilt: i < 3000 ? 1980 : 2000,
					    random: Math.random() };
				//counts[obj.yearBuilt] = counts[obj.yearBuilt] + 1; 
				data.push(obj);
			}			
			data = data.sortOn('random', Array.NUMERIC);
			
/* 			for (var yr:String in counts) {
				trace(yr + ": " + counts[yr]);
			} */
			
		}
		
		public function testWhereEquals():void
		{		
			var results:Array;
			results = data.filter(whereEquals('propertyType', 'Town'));
			assertEquals(1000, results.length);
			results = data.filter(whereEquals('propertyType', 'Family'));
			assertEquals(1500, results.length);
			results = data.filter(whereEquals('propertyType', 'Apartment'));
			assertEquals(2500, results.length);
			results = data.filter(whereEquals('yearBuilt', 1980));
			assertEquals(1500, results.length);
			results = data.filter(whereEquals('yearBuilt', 1950));
			assertEquals(1000, results.length);
		}
		
		public function testWhereBetween():void
		{
			var results:Array;
			results = data.filter(whereBetween('id', 0, 99));
			assertEquals(100, results.length);			
			results = data.filter(whereBetween('yearBuilt', 1950, 1980));
			assertEquals(2500, results.length);			
		}

 		public function testWhereIn():void
		{		
			var results:Array;
			results = data.filter(whereIn('propertyType', [ 'Town', 'Family' ]));
			assertEquals(2500, results.length);			
			results = data.filter(whereIn('propertyType', [ 'Apartment', 'Family' ]));
			assertEquals(4000, results.length);			
			results = data.filter(whereIn('propertyType', [ 'Apartment' ]));
			assertEquals(2500, results.length);			
		}
		
 		public function testWHEREIN():void
		{		
			var results:Array;
 			results = data.filter(WHERE('propertyType', IN('Town', 'Family')));
			assertEquals(2500, results.length);
			results = data.filter(WHERE('propertyType', IN('Apartment', 'Family')));
			assertEquals(4000, results.length);			
			results = data.filter(WHERE('propertyType', IN('Apartment')));
			assertEquals(2500, results.length);			
		}			

		public function testORWHEREEQUALS():void
		{
			var results:Array;
			results = data.filter( OR( WHERE('propertyType', EQUALS('Town')), WHERE('propertyType', EQUALS('Family')) ) );
			assertEquals(2500, results.length);
		}

		public function testORwhereEquals():void
		{
			var results:Array;
			results = data.filter(OR(whereEquals('propertyType','Town')));
			assertEquals(1000, results.length);
			results = data.filter(OR(whereEquals('propertyType','Town'), whereEquals('propertyType','Family')));
			assertEquals(2500, results.length);
			results = data.filter(OR(whereEquals('propertyType','Town'), whereEquals('propertyType','Apartment'), whereEquals('propertyType','Family')));
			assertEquals(5000, results.length);
			results = data.filter(OR(whereEquals('propertyType','Town'), whereEquals('propertyType','Apartment'), whereEquals('propertyType','Family'), whereEquals('propertyType','Broken'), whereEquals('propertyType','Nonsense')));
			assertEquals(5000, results.length);
			results = data.filter(OR(whereEquals('propertyType','Town'), whereEquals('yearBuilt','2000')));
			assertEquals(3000, results.length);
			results = data.filter(OR(whereEquals('propertyType','Town'), whereEquals('yearBuilt', 2000)));
			assertEquals(3000, results.length);
			results = data.filter(OR(whereEquals('yearBuilt','2000')));
			assertEquals(2000, results.length);

			var clauses:Array = [];
			clauses.push(whereEquals('yearBuilt','2000'));
			clauses.push(whereEquals('propertyType','Town'));
			clauses.push(whereEquals('id','1500'));
			results = data.filter(OR(clauses));
			assertEquals(3001, results.length);

		}
		
		public function testWhereBetween2():void
		{
			var results:Array;
			results = data.filter(whereBetween('yearBuilt', 1940, 1970));
			assertEquals(1000, results.length);
		}
		
		public function testWHEREBETWEEN():void
		{
			var results:Array;
			results = data.filter(WHERE('yearBuilt', BETWEEN(1940, 1970)));
			assertEquals(1000, results.length);
		}
		
		public function testANDWHERE():void
		{
			var results:Array;
			results = data.filter(AND(WHERE('yearBuilt', GTEQ(1940)), WHERE('yearBuilt', LTEQ(1970))));
			assertEquals(1000, results.length);

			var clauses:Array = [];
			clauses.push(whereEquals('yearBuilt','2000'));
			clauses.push(whereEquals('propertyType','Town'));
			clauses.push(whereEquals('id','1500'));
			results = data.filter(AND(clauses));
			assertEquals(0, results.length);
		}

		public function testNOT():void
		{
			var results1:Array = data.filter(WHERE('yearBuilt', GT(1970)));
			assertEquals(4000, results1.length);
			var results2:Array = data.filter(NOT(WHERE('yearBuilt', LTEQ(1970))));
			assertEquals(results1.length, results2.length);
		}
		
		public function testGroupBy():void
		{
			var results:Dictionary = groupBy(data, 'propertyType');			
			assertEquals(1000, results['Town'].length);
			assertEquals(1500, results['Family'].length);
			assertEquals(2500, results['Apartment'].length);

			results = groupBy(data, 'yearBuilt');			
			assertEquals(1000, results[1950].length);
			assertEquals(1500, results[1980].length);
			assertEquals(500,  results[1990].length);
			assertEquals(2000, results[2000].length);
		}
		
		public function testParser():void
		{
			var results:Array = data.filter(parseQuery("WHERE propertyType == 'Town'"));			
			assertEquals(1000, results.length);
			results = data.filter(parseQuery("WHERE propertyType == 'Family'"));			
			assertEquals(1500, results.length);
			results = data.filter(parseQuery("WHERE propertyType == 'Apartment'"));			
			assertEquals(2500, results.length);
			results = data.filter(parseQuery("WHERE yearBuilt <= '1950'"));			
			assertEquals(1000, results.length);
			results = data.filter(parseQuery("WHERE yearBuilt < '1951'"));			
			assertEquals(1000, results.length);
		}
		
	}
}