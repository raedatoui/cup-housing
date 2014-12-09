package com.stamen.geom {
import flash.geom.Point;
import flash.display.DisplayObject;

public class PointUtils {
    public static function unit(p:Point):Point {
        var line:Line = new Line(new Point(0, 0), p);
        line.length = 1;
        return line.end;
    }

    public static function contextualize(p:Point, fromContext:DisplayObject, toContext:DisplayObject):Point {
        return toContext.globalToLocal(fromContext.localToGlobal(p));
    }
}
}