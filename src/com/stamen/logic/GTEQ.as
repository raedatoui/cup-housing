package com.stamen.logic
{
	public function GTEQ(min:Number):Function
	{
		return function(value:Number):Boolean {
			return value >= min;
		};
	}
}