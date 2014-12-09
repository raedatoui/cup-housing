package com.stamen.logic {
public function NOT(...funcs):Function {
    if (funcs.length == 1) {
        if (funcs[0] is Array) {
            funcs = funcs[0];
        }
    }
    return function (datum:Object, i:int, array:Array):Boolean {
        for each (var f:Function in funcs) {
            if (f(datum, i, array)) {
                return false;
            }
        }
        return true;
    }
}
}