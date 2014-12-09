package com.stamen.geom {
import flash.geom.Point;
import flash.display.Graphics;

public class Circle {
    public var center:Point;
    public var radius:Number;

    public function Circle(radius:Number = 0, center:Point = null) {
        this.radius = radius;
        this.center = center || new Point();
    }

    public function equals(other:Circle):Boolean {
        if (other) {
            return radius == other.radius && center.equals(other.center);
        }
        else {
            return false;
        }
    }

    public function clone():Circle {
        return new Circle(radius, center.clone());
    }

    public function draw(graphics:Graphics):void {
        graphics.drawCircle(center.x, center.y, radius);
    }
}
}
