package com.stamen.easing {
	public function bounceEaseInOut (t:Number, b:Number, c:Number, d:Number):Number {
		if (t < d/2) return bounceEaseIn (t*2, 0, c, d) * .5 + b;
		else return bounceEaseOut (t*2-d, 0, c, d) * .5 + c*.5 + b;
	}
}