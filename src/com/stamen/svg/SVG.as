package com.stamen.svg {
import com.stamen.geom.Polygon;
import com.stamen.graphics.color.IColor;
import com.stamen.graphics.color.RGB;

import flash.geom.Point;
import flash.geom.Rectangle;

public class SVG {
    public static const SVG_NS:Namespace = new Namespace('http://www.w3.org/2000/svg');

    protected var _svg:XML;

    public function SVG(svg:XML) {
        _svg = svg.copy();
    }

    private var _rect:Rectangle;

    public function getRect():Rectangle {
        if (!_rect) {
            default xml namespace = SVG_NS;
            _rect = new Rectangle(0, 0, 0, 0);
            _rect.x = parseMeasurement(_svg.@x.toString());
            _rect.y = parseMeasurement(_svg.@y.toString());
            _rect.width = parseMeasurement(_svg.@width.toString());
            _rect.height = parseMeasurement(_svg.@height.toString());
        }
        return _rect.clone();
    }

    private var _polygons:Array;

    public function getPolygons():Array {
        if (!_polygons) {
            default xml namespace = SVG_NS;

            _polygons = new Array();
            var polyNodes:XMLList = _svg..polygon;
            for each (var polyNode:XML in polyNodes) {
                var poly:Polygon = getPolygon(polyNode);
                _polygons.push(poly);
            }
        }
        return _polygons.concat();
    }

    public static function getPolygon(xml:XML):Polygon {
        default xml namespace = SVG_NS;

        var poly:Polygon = new Polygon();
        var pointString:String = xml.@points.toString();
        if (pointString.length > 0) {
            poly.points = getPointsFromString(pointString);
        }
        return poly;
    }

    public static function getColorFromString(str:String):IColor {
        if (str.substr(0, 1) == '#') {
            return RGB.fromHex(str.substr(1));
        }
        return null;
    }

    public static function getPointsFromString(str:String):Array {
        var pointStrings:Array = str.split(' ');
        var points:Array = new Array();
        for each (var pointString:String in pointStrings) {
            if (pointString.length == 0 || pointString.indexOf(',') == -1) continue;
            var xy:Array = pointString.split(',');
            var point:Point = new Point(parseFloat(xy[0]), parseFloat(xy[1]));
            // trace('parsed point: "' + pointString + '" into: ' + point);
            points.push(point);
        }
        return points;
    }

    public static function parseMeasurement(str:String):Number {
        // assume pixels if no measurement is provided
        if (!str.match(/[a-z]{2}$/)) {
            return parseFloat(str);
        }
        var m:String = str.substring(str.length - 2);
        if (m == 'px') {
            return parseFloat(str.substr(0, str.length - 2));
        }
        return NaN;
    }
}
}