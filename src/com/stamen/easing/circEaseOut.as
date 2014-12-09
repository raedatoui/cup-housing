package com.stamen.easing {
public function circEaseOut(t:Number, b:Number, c:Number, d:Number):Number {
    return c * Math.sqrt(1 - (t = t / d - 1) * t) + b;
}
}