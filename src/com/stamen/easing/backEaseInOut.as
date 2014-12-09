package com.stamen.easing {
public function backEaseInOut(t:Number, b:Number, c:Number, d:Number, s:Number = 1.70158):Number {
    if ((t /= d / 2) < 1) return c / 2 * (t * t * (((s *= (1.525)) + 1) * t - s)) + b;
    return c / 2 * ((t -= 2) * t * (((s *= (1.525)) + 1) * t + s) + 2) + b;
}
}
