package com.stamen.easing {
public function sineEaseOut(t:Number, b:Number, c:Number, d:Number):Number {
    return c * Math.sin(t / d * HALF_PI) + b;
}
}