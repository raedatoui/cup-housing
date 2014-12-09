package com.stamen.logic {
public function whereBetween(property:String, lower:Number, upper:Number):Function {
    return function (datum:Object, i:int, array:Array):Boolean {
        return lower <= datum[property] && datum[property] <= upper;
    }
}
}