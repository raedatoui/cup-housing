package com.stamen.logic {
public function parseQuery(query:String):Function {
    var terms:Array = query.split(" ");
    var term:String = terms.shift() as String;
    switch (term) {
        case 'WHERE':
            if (terms.length >= 3) {
                var left:String = terms.shift() as String;
                var exp:String = terms.shift() as String;
                var right:String = terms.shift() as String;
                if (right.charAt(0) == "'" && right.charAt(right.length - 1) == "'") {
                    right = right.substr(1, right.length - 2);
                }
                var rightVal:Number = parseFloat(right);
                var f:Function = null;
                switch (exp) {
                    case '==':
                        f = EQUALS(right);
                        break;
                    case '<=':
                        f = LTEQ(rightVal);
                        break;
                    case '>=':
                        f = GTEQ(rightVal);
                        break;
                    case '<':
                        f = LT(rightVal);
                        break;
                    case '>':
                        f = GT(rightVal);
                        break;
                }
                if (f != null) {
                    return WHERE(left, f);
                }
            }
            break;
    }
    return function (datum:Object, i:int, array:Array):Boolean {
        return false;
    }
}
}