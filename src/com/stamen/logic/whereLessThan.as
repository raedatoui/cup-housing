package com.stamen.logic
{
	public function whereLessThan(property:String, upper:Number):Function
	{
		return function(datum:Object, i:int, array:Array):Boolean {
			return datum[property] < upper;
		}
	}
}