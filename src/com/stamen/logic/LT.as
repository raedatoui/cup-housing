package com.stamen.logic
{
	public function LT(max:Number):Function
	{
		return function(value:Number):Boolean {
			return value < max;
		};
	}
}