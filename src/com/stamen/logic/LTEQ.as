package com.stamen.logic
{
	public function LTEQ(max:Number):Function
	{
		return function(value:Number):Boolean {
			return value <= max;
		};
	}
}