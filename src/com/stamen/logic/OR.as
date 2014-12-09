package com.stamen.logic {
/*  	public function or(a:Function, b:Function):Function
 {
 return function(datum:Object, i:int, array:Array):Boolean
 {
 return a(datum, i, array) || b(datum, i, array);
 }
 } */

public function OR(...funcs):Function {
    if (funcs.length == 1) {
        if (funcs[0] is Array) {
            funcs = funcs[0];
        }
    }
    return function (datum:Object, i:int, array:Array):Boolean {
        for each (var f:Function in funcs) {
            if (f(datum, i, array)) {
                return true;
            }
        }
        return false;
    }
}
}
