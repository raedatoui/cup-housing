package com.stamen.logic
{
	public function EQUALS(compare:Object):Function
	{
		return function(value:Object):Boolean {
			return value == compare;
		};
	}
}