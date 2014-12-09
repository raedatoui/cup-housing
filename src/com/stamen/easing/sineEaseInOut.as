package com.stamen.easing {
public function sineEaseInOut(t:Number, b:Number, c:Number, d:Number):Number {
    return -c / 2 * (Math.cos(Math.PI * t / d) - 1) + b;
}
}