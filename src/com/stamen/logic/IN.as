package com.stamen.logic
{
	public function IN(...list):Function
	{
		return function(value:Object):Boolean {
			return list.indexOf(value) >= 0;
		};
	}
}