package com.cup.output {

	

import flash.geom.Point;



	

	public class BoroughData {

		

		

		//public var bleh:Point = new Point(0,0);

		public var id:String;

		public var pointArrays:Array = new Array;

		public var subBorough:String;

		public var translate:Point;

		public var center:Point;

		

		public var top:Number;

		public var bottom:Number;

		public var left:Number;

		public var right:Number;

		

		public function BoroughData (i:String):void
		{

			//trace(i.subString(i.length - 4, i.length - 1));

			

			id = i.substring(i.length - 3, i.length);

			

			translate = new Point(0,0);

		}

		

		

		public function addPoints(p:String):void
		{

			var points:Array = [];

			var tempString:String = "";

			

			var tempArray:Array = p.split(" ");

			var digits:RegExp = /[0-9\.\-]+/g;

	

			

			for each(var str:String in tempArray)

			{

				var matchResult:Array = str.match(digits);

				//trace(matchResult[0],Number(matchResult[0]),matchResult[1],Number(matchResult[1]));

				

				

				if(matchResult)

				{

					if(matchResult[0] && matchResult[1])

					{

						if(id != "und")

						{

							matchResult[1] *= -1;

						}

						points.push(new Point(matchResult[0],matchResult[1]));

					}

				}

				

				

				

				

				//str = str.match(spaces);

			}

			

			pointArrays.push(points);

			

			setCenter();

		}

		

		public function setTranslate(m:String):void
		{
			var digits:RegExp = /[0-9\.\-]+/g;

			var tempArray:Array = m.match(digits);

			//trace("translation:",m,tempArray[4],tempArray[5]);

			translate = new Point(tempArray[4],tempArray[5]);

			setBounds();
		}

		

		public function setBounds():void
		{

			top = 1000;

			bottom = -1000;

			left = 1000;

			right = -1000;

			

			/*var lenA:int = pointArrays.length;

			

			for(var i:int = 0; i<lenA; i++)

			{

				var lenP:int = pointArrays[i].length;*/

				

				

				

			for each(var pA:Array in pointArrays)

			{

				for each(var p:Point in pA)

				{

					p.x += translate.x;

					p.y += translate.y;

					

					left = Math.min(left,p.x);

					right = Math.max(right,p.x);

					top = Math.min(top,p.y);

					bottom = Math.max(bottom,p.y);

				}

			}

				

			trace(id+":",left,right,top,bottom);
		}

		

		public function setCenter():void
		{

			var biggestPointArrayIndex:int = 0;

			var biggestPointArrayLength:int = 0;

			var len:int = pointArrays.length;

			

			for(var i:int = 0;i<len;i++)

			{

				if(pointArrays[i].length > biggestPointArrayLength)

				{

					biggestPointArrayLength = pointArrays[i].length;

					biggestPointArrayIndex = i;

				}

			}

			

			var tempX:Number = 0;

			var tempY:Number = 0;

			var tempCount:int = 0;

			

			//trace("begin averaging:");

			for each(var p:Point in pointArrays[biggestPointArrayIndex])

			{

				if(p.x)

				{

					tempX += p.x;

					tempY += p.y;

					tempCount++;

					

					//trace(tempX,tempY,p.x,p.y);

				}

			}

			

			//center = new Point((right-left)/2,(bottom-top)/2);

			

			center = new Point(tempX/tempCount,tempY/tempCount);

			//trace(center);

			//trace();

		}

		

	}

}