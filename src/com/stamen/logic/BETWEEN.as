package com.stamen.logic {
public function BETWEEN(min:Number, max:Number):Function {
    return function (value:Number):Boolean {
        return min <= value && value <= max;
    };
}
}