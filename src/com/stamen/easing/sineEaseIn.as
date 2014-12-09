package com.stamen.easing {
public function sineEaseIn(t:Number, b:Number, c:Number, d:Number):Number {
    return -c * Math.cos(t / d * HALF_PI) + c + b;
}
}