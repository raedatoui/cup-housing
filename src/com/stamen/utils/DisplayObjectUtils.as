package com.stamen.utils {
import com.stamen.geom.GeometryUtils;

import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.geom.ColorTransform;
import flash.geom.Transform;

public final class DisplayObjectUtils {
    public static function children(parent:DisplayObjectContainer):Array {
        var objects:Array = new Array();
        for (var i:uint = 0; i < parent.numChildren; i++) {
            objects.push(parent.getChildAt(i));
        }
        return objects;
    }

    public static function contains(parent:DisplayObjectContainer, child:DisplayObject, recursive:Boolean = true):Boolean {
        if (!parent || !child) return false;

        if (parent.contains(child)) {
            return true;
        }
        else if (!recursive) {
            return false;
        }

        var p:DisplayObject = child.parent;
        while (p) {
            if (p == parent) return true;
            p = p.parent;
        }
        return false;
    }

    public static function interpolateTransforms(obj:DisplayObject, a:Transform, b:Transform, f:Number):Transform {
        if (f == 0) return a;
        else if (f == 1) return b;

        var result:Transform = new Transform(obj);
        result.colorTransform = interpolateColorTransforms(a.colorTransform, b.colorTransform, f);
        result.matrix = GeometryUtils.interpolateMatrices(a.matrix, b.matrix, f);
        return result;
    }

    public static function interpolateColorTransforms(a:ColorTransform, b:ColorTransform, f:Number, useColor:Boolean = false):ColorTransform {
        if (f == 0) return a;
        else if (f == 1) return b;

        var result:ColorTransform = new ColorTransform();
        var properties:Array = useColor
                ? ['color', 'alphaMultiplier', 'alphaOffset']
                : ['redMultiplier', 'greenMultiplier', 'blueMultiplier', 'alphaMultiplier',
            'redOffset', 'greenOffset', 'blueOffset', 'alphaOffset'];
        for each (var p:String in properties) {
            result[p] = MathUtils.map(f, 0, 1, a[p], b[p]);
        }
        return result;
    }
}
}