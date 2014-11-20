package com.stamen.easing {
	public function quadEaseInOut (t:Number, b:Number, c:Number, d:Number):Number {
		if ((t/=d/2) < 1) return c/2*t*t + b;
		return -c/2 * ((--t)*(t-2) - 1) + b;
	}
}