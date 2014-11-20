package com.stamen.easing {
	public function cubicEaseIn (t:Number, b:Number, c:Number, d:Number):Number {
		return c*(t/=d)*t*t + b;
	}
}