package com.stamen.easing {
public function quartEaseIn(t:Number, b:Number, c:Number, d:Number):Number {
    return c * (t /= d) * t * t * t + b;
}
}