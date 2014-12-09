package com.stamen.logic {
public function whereLessThanOrEqual(property:String, upper:Number):Function {
    return function (datum:Object, i:int, array:Array):Boolean {
        return datum[property] <= upper;
    }
}
}