package com.stamen.easing {
public function backEaseIn(t:Number, b:Number, c:Number, d:Number, s:Number = 1.70158):Number {
    return c * (t /= d) * t * ((s + 1) * t - s) + b;
}
}
