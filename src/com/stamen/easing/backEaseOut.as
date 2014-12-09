package com.stamen.easing {
public function backEaseOut(t:Number, b:Number, c:Number, d:Number, s:Number = 1.70158):Number {
    return c * ((t = t / d - 1) * t * ((s + 1) * t + s) + 1) + b;
}
}
