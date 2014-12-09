package com.stamen.logic {
public function WHERE(property:String, f:Function):Function {
    return function (datum:Object, i:int, array:Array):Boolean {
        return f(datum[property]);
    }
}
}