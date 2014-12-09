package com.stamen.logic {
import flash.utils.Dictionary;

public function groupBy(array:Array, property:String):Dictionary {
    var groups:Dictionary = new Dictionary();
    var group:Array;
    for each (var o:Object in array) {
        group = groups[o[property]] as Array;
        if (!group) {
            group = [];
            groups[o[property]] = group;
        }
        group.push(o);
    }
    return groups;
}
}