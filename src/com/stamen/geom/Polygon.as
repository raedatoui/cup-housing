package com.stamen.geom {
import com.adobe.utils.StringUtil;

import flash.display.Graphics;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;

public class Polygon {
    public var points:Array = new Array();
    public var x:Number = 0;
    public var y:Number = 0;
    public var name:String;

    public static function fromString(pointsString:String, ...rest):Polygon {
        var f:Function = (rest.length > 0 && rest[0] is Function)
                ? rest[0] as Function
                : null;
        var pointStrings:Array = StringUtil.trim(pointsString).split(/ +/);
        var poly:Polygon = new Polygon();
        for each (var pointString:String in pointStrings) {
            var parts:Array = pointString.split(',');
            var point:Point = new Point(parseFloat(parts[0]), parseFloat(parts[1]));
            if (f != null) {
                point.x = f(point.x);
                point.y = f(point.y);
            }
            poly.points.push(point);
        }
        return poly;
    }

    public function Polygon(points:Array = null) {
        if (points) this.points = points;
    }

    public function clone():Polygon {
        var poly:Polygon = new Polygon();
        for each (var point:Point in points) {
            poly.points.push(point.clone());
        }
        poly.name = name;
        return poly;
    }

    public function getRect():Rectangle {
        var xMin:Number = Number.POSITIVE_INFINITY;
        var xMax:Number = Number.NEGATIVE_INFINITY;
        var yMin:Number = Number.POSITIVE_INFINITY;
        var yMax:Number = Number.NEGATIVE_INFINITY;
        for each (var point:Point in points) {
            xMin = Math.min(xMin, point.x);
            xMax = Math.max(xMax, point.x);
            yMin = Math.min(yMin, point.y);
            yMax = Math.max(yMax, point.y);
        }
        return new Rectangle(xMin, yMin, xMax - xMin, yMax - yMin);
    }

    public function get centroid():Point {
        var rect:Rectangle = getRect();
        return new Point(rect.x + rect.width / 2, rect.y + rect.height / 2);
    }

    public function applyMatrix(matrix:Matrix):void {
        for (var i:uint = 0; i < points.length; i++) {
            points[i] = matrix.transformPoint(points[i] as Point);
        }
    }

    public function translate(dx:Number, dy:Number):void {
        var matrix:Matrix = new Matrix();
        matrix.translate(dx, dy);
        applyMatrix(matrix);
    }

    public function rotate(radians:Number):void {
        var matrix:Matrix = new Matrix();
        matrix.translate(x, y);
        matrix.rotate(radians);
        matrix.translate(-x, -y);
        applyMatrix(matrix);
    }

    public function scale(sx:Number, sy:Number):void {
        var matrix:Matrix = new Matrix();
        matrix.translate(x, y);
        matrix.scale(sx, sy);
        matrix.translate(-x, -y);
        applyMatrix(matrix);
    }

    public function draw(graphics:Graphics, clear:Boolean = false, close:Boolean = true):void {
        if (points && points.length > 0) {
            var start:Point = points[0] as Point;
            if (clear) graphics.clear();
            graphics.moveTo(x + start.x, y + start.y);
            for (var i:uint = 1; i < points.length; i++) {
                var point:Point = points[i] as Point;
                // trace(' poly points[' + i + '] = ' + point);
                graphics.lineTo(x + point.x, y + point.y);
            }
            if (close) {
                graphics.lineTo(x + start.x, y + start.y);
            }
        }
    }
}
}