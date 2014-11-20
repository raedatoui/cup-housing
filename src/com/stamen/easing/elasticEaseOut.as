package com.stamen.easing {
	public function elasticEaseOut (t:Number, b:Number, c:Number, d:Number, a:Number = 0, p:Number = 0):Number {
		var s:Number;
		if (t==0) return b;  if ((t/=d)==1) return b+c;  if (!p) p=d*.3;
		if (!a || a < Math.abs(c)) { a=c; s = p/4; }
		else s = p/TWO_PI * Math.asin (c/a);
		return (a*Math.pow(2,-10*t) * Math.sin( (t*d-s)*TWO_PI/p ) + c + b);
	}
}