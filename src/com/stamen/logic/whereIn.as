package com.stamen.logic
{
	public function whereIn(property:String, values:Array):Function
	{
		return function(datum:Object, i:int, array:Array):Boolean {
			return values.indexOf(datum[property]) >= 0;
		}
	}
}