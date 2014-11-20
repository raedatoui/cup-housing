package com.stamen.logic
{
	public function whereGreaterThan(property:String, lower:Number):Function
	{
		return function(datum:Object, i:int, array:Array):Boolean {
			return datum[property] > lower;
		}
	}
}