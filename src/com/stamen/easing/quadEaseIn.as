package com.stamen.easing {
	public function quadEaseIn (t:Number, b:Number, c:Number, d:Number):Number {
		return c*(t/=d)*t + b;
	}
}