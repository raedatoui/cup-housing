package com.stamen.utils {
public class XMLUtils {
    public static function getAttribute(node:*, attr:String):String {
        return node.attribute(attr).toXMLString();
    }

    public static function getNodeText(node:*):String {
        return node.text().toString();
    }
}
}