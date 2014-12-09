package com.stamen.utils {
import flash.geom.Point;

public class MathUtils {
    public static function random(min:Number, max:Number, round:Boolean = false):Number {
        var n:Number = min + Math.random() * (max - min);
        return round ? Math.round(n) : n;
    }

    public static function bound(value:Number, min:Number, max:Number):Number {
        if (!isFinite(value)) value = 0;
        return Math.min(max, Math.max(min, value));
    }

    public static function normalize(value:Number, min:Number, max:Number, bound:Boolean = false):Number {
        if (bound)
            value = MathUtils.bound(value, min, max);
        return (value - min) / (max - min);
    }

    public static function quantize(value:Number, divisor:Number, f:Function = null):Number {
        if (f == null) f = Math.floor;
        return f(value / divisor) * divisor;
    }

    public static function map(value:Number, minA:Number, maxA:Number, minB:Number, maxB:Number):Number {
        return minB + (maxB - minB) * normalize(value, minA, maxA);
    }

    public static function logn(x:Number, base:Number):Number {
        if (!base) base = Math.E;
        return Math.log(x) / Math.log(base);
    }

    public static function degrees(radians:Number):Number {
        return radians * 180 / Math.PI;
    }

    public static function radians(degrees:Number):Number {
        return degrees * Math.PI / 180;
    }

    public static function normalizeRadians(radians:Number):Number {
        radians %= Math.PI * 2;
        return (radians < 0)
                ? radians + Math.PI * 2
                : radians;
    }

    public static function cubicBezier(t:Number, b:Number, c:Number,
                                       d:Number, p1:Number, p2:Number):Number {
        return ((t /= d) * t * c +
                3 * (1 - t) * (t * (p2 - b) +
                (1 - t) * (p1 - b))) * t + b;
    }

    public static function even(num:Number):Number {
        return (num % 2 == 1) ? num - 1 : num;
    }

    public static function odd(num:Number):Number {
        return (num % 2 == 0) ? num - 1 : num;
    }

    public static function sortPointsByDistance(points:Array, center:Point):void {
        var distances:Array = new Array();
        for each (var obj:Object in points) {
            var p:Point = (obj is Point) ? (obj as Point) : new Point(obj.x, obj.y);
            distances.push({point: obj, distance: Point.distance(center, p)});
        }
        distances.sortOn('distance');
        for (var i:uint = 0; i < distances.length; i++) {
            distances[i] = distances[i].point;
        }
        var func:Function = function (a:Object, b:Object):int {
            return distances.indexOf(b) - distances.indexOf(a);
        };
        points.sort(func);
    }
}
}
