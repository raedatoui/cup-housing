package com.stamen.easing {
public function circEaseIn(t:Number, b:Number, c:Number, d:Number):Number {
    return -c * (Math.sqrt(1 - (t /= d) * t) - 1) + b;
}
}