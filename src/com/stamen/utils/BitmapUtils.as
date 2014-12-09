package com.stamen.utils {
import com.quasimondo.geom.ColorMatrix;
import com.stamen.graphics.color.RGB;

import flash.display.BitmapData;
import flash.display.BlendMode;
import flash.filters.BlurFilter;
import flash.filters.ColorMatrixFilter;
import flash.filters.ConvolutionFilter;
import flash.geom.Point;
import flash.geom.Rectangle;

public class BitmapUtils {
    public static const CLEAR:uint = 0x00FFFFFF;
    public static const WHITE:uint = 0xFFFFFFFF;
    public static const BLACK:uint = 0xFF000000;

    public static const MASK_RGB:uint = 0x00FFFFFF;
    public static const MASK_ARGB:uint = 0xFFFFFFFF;
    public static const MASK_ALPHA:uint = 0xFF000000;

    public static const SOBEL_GRAY:uint = 0xFF7F7F7F;

    public static const SOBEL_VERTICAL:ConvolutionFilter = new ConvolutionFilter(3, 3,
            [-1, 0, 1,
                -2, 0, 2,
                -1, 0, 1],
            1, 127, false);

    public static const SOBEL_HORIZONTAL:ConvolutionFilter = new ConvolutionFilter(3, 3,
            [-1, -2, -1,
                0, 0, 0,
                1, 2, 1],
            1, 127, false);

    public static const BLUESCALE:ColorMatrixFilter = new ColorMatrixFilter([0, 0, 0, 0, 0,
        0, 0, 0, 0, 0,
        1 / 3, 1 / 3, 1 / 3, 0, 0,
        0, 0, 0, 1, 0]);

    public static function edgify(bitmap:BitmapData, modifyOriginal:Boolean = true, blur:Number = 0, threshold:uint = 127):BitmapData {
        var source:BitmapData = bitmap.clone();

        var p:Point = new Point();
        var rect:Rectangle = bitmap.rect;

        if (blur > 0) {
            source.applyFilter(source, rect, p, new BlurFilter(blur, blur, 1));
        }

        const MASK_BLUE:uint = 0xFF;
        source.applyFilter(source, rect, p, BLUESCALE);

        var edges:BitmapData = new BitmapData(source.width, source.height, true, CLEAR);
        var horizonal:BitmapData = edges.clone();
        var vertical:BitmapData = edges.clone();
        horizonal.applyFilter(source, rect, p, SOBEL_HORIZONTAL);
        vertical.applyFilter(source, rect, p, SOBEL_VERTICAL);
        edges.threshold(horizonal, rect, p, '>', threshold, 0x00, MASK_BLUE, true);
        vertical.threshold(vertical, rect, p, '>', threshold, 0x00, MASK_BLUE, true);
        edges.draw(vertical, null, null, BlendMode.ADD);

        var m:ColorMatrix = new ColorMatrix();
        m.invert();

        edges.applyFilter(edges, rect, p, m.filter);

        if (modifyOriginal) {
            bitmap.threshold(edges, rect, p, '<', threshold, CLEAR, MASK_BLUE);
        }
        return edges;
    }

    public static function quantizeBitmap(bitmap:BitmapData, q:uint = 0x33, inPlace:Boolean = true, f:Function = null):BitmapData {
        var out:BitmapData = inPlace ? bitmap : bitmap.clone();
        for (var y:int = 0; y <= out.height; y++) {
            for (var x:int = 0; x <= out.width; x++) {
                var c:uint = out.getPixel(x, y);
                var rgb:RGB = RGB.fromHex(c).quantize(q, f);
                out.setPixel(x, y, rgb.hex);
            }
        }
        return inPlace ? null : out;
    }
}
}