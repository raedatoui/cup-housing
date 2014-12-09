package com.stamen.geom {
import flash.display.DisplayObject;
import flash.geom.Matrix;

public class MatrixProxy {
    public var startMatrix:Matrix;
    public var endMatrix:Matrix;
    public var interpolatedMatrix:Matrix;
    public var target:DisplayObject;

    protected var _mix:Number = 0;

    public function MatrixProxy(target:DisplayObject = null, start:Matrix = null, end:Matrix = null) {
        this.target = target;
        startMatrix = start;
        endMatrix = end;
    }

    public function get mix():Number {
        return _mix;
    }

    public function set mix(value:Number):void {
        _mix = value;
        updateMix();
    }

    public function updateMix():void {
        if (!startMatrix || !endMatrix || isNaN(mix)) {
            interpolatedMatrix = null;
            return;
        }
        interpolatedMatrix = GeometryUtils.interpolateMatrices(startMatrix, endMatrix, mix);
        if (target) target.transform.matrix = interpolatedMatrix;
    }
}
}