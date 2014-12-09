package com.stamen.logic {
public function GT(min:Number):Function {
    return function (value:Number):Boolean {
        return value > min;
    };
}
}