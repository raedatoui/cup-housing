package com.stamen.easing {
public function linearEase(t:Number, b:Number, c:Number, d:Number):Number {
    return c * t / d + b;
}
}