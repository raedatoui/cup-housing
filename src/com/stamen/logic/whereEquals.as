package com.stamen.logic
{
	public function whereEquals(property:String, value:Object):Function
	{
		return function(datum:Object, i:int, array:Array):Boolean {
			return datum[property] == value;
		}
	}
}