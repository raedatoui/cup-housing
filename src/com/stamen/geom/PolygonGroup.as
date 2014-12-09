package com.stamen.geom {
import flash.display.Graphics;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;

public class PolygonGroup extends Polygon {
    public var polygons:Array;

    public function PolygonGroup(polygons:Array = null) {
        this.polygons = polygons ? polygons.concat() : new Array();
    }

    override public function get centroid():Point {
        var tx:Number = 0;
        var ty:Number = 0;
        var len:int = polygons.length;
        for each (var poly:Polygon in polygons) {
            var centroid:Point = poly.centroid;
            tx += centroid.x;
            ty += centroid.y;
        }
        return new Point(tx / len, ty / len);
    }

    override public function getRect():Rectangle {
        var xMin:Number = Number.POSITIVE_INFINITY;
        var xMax:Number = Number.NEGATIVE_INFINITY;
        var yMin:Number = Number.POSITIVE_INFINITY;
        var yMax:Number = Number.NEGATIVE_INFINITY;
        for each (var poly:Polygon in polygons) {
            var rect:Rectangle = poly.getRect();
            xMin = Math.min(xMin, rect.left);
            xMax = Math.max(xMax, rect.right);
            yMin = Math.min(yMin, rect.top);
            yMax = Math.max(yMax, rect.bottom);
        }
        return new Rectangle(xMin, yMin, xMax - xMin, yMax - yMin);
    }

    override public function applyMatrix(matrix:Matrix):void {
        for each (var poly:Polygon in polygons) {
            poly.applyMatrix(matrix);
        }
    }

    override public function rotate(radians:Number):void {
        var matrix:Matrix = new Matrix();
        matrix.rotate(radians);
        for each (var poly:Polygon in polygons) {
            poly.applyMatrix(matrix);
        }
    }

    override public function scale(sx:Number, sy:Number):void {
        var matrix:Matrix = new Matrix();
        matrix.scale(sx, sy);
        for each (var poly:Polygon in polygons) {
            poly.applyMatrix(matrix);
        }
    }

    override public function clone():Polygon {
        var cloned:PolygonGroup = new PolygonGroup();
        for each (var poly:Polygon in polygons) {
            cloned.polygons.push(poly.clone());
        }
        return cloned;
    }

    override public function draw(graphics:Graphics, clear:Boolean = false, close:Boolean = true):void {
        for (var i:int = 0; i < polygons.length; i++) {
            (polygons[i] as Polygon).draw(graphics, clear && i == 0, close);
        }
    }
}
}