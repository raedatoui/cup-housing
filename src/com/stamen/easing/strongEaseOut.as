﻿package com.stamen.easing {
public function strongEaseOut(t:Number, b:Number, c:Number, d:Number):Number {
    return c * ((t = t / d - 1) * t * t * t * t + 1) + b;
}
}
