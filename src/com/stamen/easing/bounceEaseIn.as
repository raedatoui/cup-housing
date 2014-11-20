package com.stamen.easing {
	public function bounceEaseIn (t:Number, b:Number, c:Number, d:Number):Number {
		return c - bounceEaseOut(d-t, 0, c, d) + b;
	}
}