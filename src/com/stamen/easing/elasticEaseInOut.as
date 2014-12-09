package com.stamen.easing {
public function elasticEaseInOut(t:Number, b:Number, c:Number, d:Number, a:Number = 0, p:Number = 0):Number {
    var s:Number;
    if (t == 0) return b;
    if ((t /= d / 2) == 2) return b + c;
    if (!p) p = d * (.3 * 1.5);
    if (!a || a < Math.abs(c)) {
        a = c;
        s = p / 4;
    }
    else s = p / TWO_PI * Math.asin(c / a);
    if (t < 1) return -.5 * (a * Math.pow(2, 10 * (t -= 1)) * Math.sin((t * d - s) * TWO_PI / p)) + b;
    return a * Math.pow(2, -10 * (t -= 1)) * Math.sin((t * d - s) * TWO_PI / p) * .5 + c + b;
}
}