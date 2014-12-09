package com.stamen.easing {
public function quadEaseOut(t:Number, b:Number, c:Number, d:Number):Number {
    return -c * (t /= d) * (t - 2) + b;
}
}