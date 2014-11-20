package com.stamen.easing {
	public function strongEaseIn(t:Number, b:Number, c:Number, d:Number):Number {
		return c*(t/=d)*t*t*t*t + b;
	}
}
