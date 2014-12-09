/*
 * vim:et sts=4 sw=4 cindent tw=120:
 * $Id: PolarCoordinate.as,v 1.5 2006/06/30 17:40:40 allens Exp $
 */

package com.stamen.geom {
import com.stamen.utils.MathUtils;

import flash.geom.Point;

public class PolarCoordinate extends Object {
    public var theta:Number = 0;
    public var radius:Number = 0;

    public static function fromCartesian(p:Point, origin:Point = null):PolarCoordinate {
        if (null == origin) origin = new Point(0, 0);

        var line:Line = new Line(origin, p);
        var theta:Number = line.radians;
        var radius:Number = line.length;

        return new PolarCoordinate(theta, radius);
    }

    public function PolarCoordinate(theta:Number, radius:Number) {
        this.theta = theta;
        this.radius = radius;
    }

    public function get degrees():Number {
        return MathUtils.degrees(this.theta);
    }

    public function set degrees(degrees:Number):void {
        this.theta = MathUtils.radians(degrees);
    }

    public function toCartesian(origin:Point = null):Point {
        if (null == origin) origin = new Point(0, 0);
        var x:Number = origin.x + this.radius * Math.cos(this.theta);
        var y:Number = origin.y + this.radius * Math.sin(this.theta);
        return new Point(x, y);
    }

    public function toString():String {
        return '[PolarCoordinate (' + this.radius + ', ' + this.theta + ' radians)]';
    }
}
}