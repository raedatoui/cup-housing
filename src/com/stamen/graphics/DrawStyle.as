package com.stamen.graphics {
import com.stamen.graphics.color.IColor;

import flash.display.BitmapData;
import flash.display.CapsStyle;
import flash.display.Graphics;
import flash.display.JointStyle;
import flash.display.LineScaleMode;
import flash.geom.Matrix;

public class DrawStyle {
    // primarily for debugging purposes
    public var name:String;
    // the fill color, may have alpha
    public var fillColor:IColor;
    // the fill bitmap; this overrides fillColor if set
    public var fillBitmap:BitmapData;

    // the line color; no stroke will be applied if this is null
    public var lineColor:IColor;
    // the line width
    public var lineWidth:Number = 0;

    // the following are passed directly to Graphics.lineStyle()
    public var pixelHinting:Boolean = false;
    public var lineScaleMode:String = LineScaleMode.NORMAL;
    public var lineCapStyle:String = CapsStyle.NONE;
    public var lineJoints:String = JointStyle.MITER;
    public var miterLimit:Number = 3.0;

    // the following are passed directly to Graphics.beginBitmapFill() if fillBitmap is set
    public var fillMatrix:Matrix;
    public var fillRepeat:Boolean = true;
    public var fillSmooth:Boolean = false;

    /**
     * The DrawStyle constructor accepts either an IColor or BitmapData as
     * a fill.
     */
    public function DrawStyle(fill:Object = null, lineColor:IColor = null, lineWidth:Number = 0) {
        if (fill is IColor) fillColor = fill as IColor;
        else if (fill is BitmapData) fillBitmap = fill as BitmapData;
        else if (fill != null) {
            throw new Error('DrawStyle() expects an IColor or BitmapData fill; got: ' + (typeof fill));
        }

        this.lineColor = lineColor;
        this.lineWidth = lineWidth;
    }

    public function start(g:Graphics, clear:Boolean = true):void {
        if (clear) g.clear();
        if (lineWidth >= 0 && lineColor) {
            g.lineStyle(lineWidth, lineColor.toHex(), lineColor.alpha,
                    pixelHinting, lineScaleMode, lineCapStyle, lineJoints, miterLimit);
        }
        else {
            g.lineStyle();
        }

        if (fillBitmap) {
            g.beginBitmapFill(fillBitmap, fillMatrix, fillRepeat, fillSmooth);
        }
        else if (fillColor) {
            g.beginFill(fillColor.toHex(), fillColor.alpha);
        }
        else {
        }
    }

    public function finish(g:Graphics):void {
        g.lineStyle();

        if (fillColor || fillBitmap) {
            g.endFill();
        }
    }

    public function clone():DrawStyle {
        var style:DrawStyle = new DrawStyle();
        copyProperties(style);
        return style;
    }

    public function copyProperties(style:DrawStyle):void {
        style.fillColor = fillColor;
        style.lineWidth = lineWidth;
        style.lineColor = lineColor ? lineColor.clone() : null;
        style.pixelHinting = pixelHinting;
        style.lineScaleMode = lineScaleMode;
        style.lineCapStyle = lineCapStyle;
        style.lineJoints = lineJoints;
        style.miterLimit = miterLimit;
        style.name = name;
    }
}
}