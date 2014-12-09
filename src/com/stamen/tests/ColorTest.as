package com.stamen.tests {
import com.stamen.utils.MathUtils;
import com.stamen.graphics.color.*;
import com.stamen.geom.PolarCoordinate;

import flash.display.Sprite;
import flash.geom.Rectangle;
import flash.geom.Point;
import flash.geom.Transform;

public class ColorTest extends Sprite {
    public function ColorTest() {
        super();
    }

    public function run():void {
        var center:Point = new Point(stage.stageWidth / 2,
                stage.stageHeight / 2);
        var inset:int = 50;
        var r:Number = center.x - inset;
        var polar:PolarCoordinate = new PolarCoordinate(0, r);
        var twoPI:Number = 2 * Math.PI;
        var step:Number = twoPI / 128;
        for (var theta:Number = twoPI; theta > 0; theta -= step) {
            var hsv:HSV = new HSV(MathUtils.degrees(polar.theta), 1, 1);
            var p:Point = polar.toCartesian(center);
            graphics.beginFill(hsv.toHex(), 75);
            graphics.drawCircle(p.x, p.y, inset);
            graphics.endFill();
            polar.theta = theta;
        }

        var rect:Rectangle = new Rectangle(inset * 2, inset * 2,
                stage.stageWidth - inset * 4,
                stage.stageHeight - inset * 4);
        rect.height /= 3;

        testRGB(rect.clone());
        rect.y += rect.height;
        testRGBA(rect.clone());
        rect.y += rect.height;
        testHSV(rect.clone());
    }

    private function drawColors(colors:Array, r:Rectangle):void {
        var x:Number = r.x;
        var step:Number = r.width / colors.length;
        for (var i:int = 0; i < colors.length; i++) {
            var c:IColor = colors[i] as IColor;
            graphics.beginFill(c.toHex(), c.alpha);
            graphics.drawRect(x, r.y, step, r.height);
            x += step;
        }
    }

    private function testRGB(r:Rectangle):void {
        var bands:int = 2;
        r.height /= bands;
        var c1:RGB = new RGB(255, 0, 0);
        var c2:RGB = new RGB(0, 0, 255);
        for (var i:int = 0; i < 2; i++) {
            var colors:Array = new Array();
            var step:Number = 0.2;
            for (var blend:Number = 0; blend <= 1; blend += step) {
                colors.push(c1.blend(c2, blend, Boolean(i)));
            }
            drawColors(colors, r);
            r.y += r.height;
        }
    }

    private function testRGBA(r:Rectangle):void {
        var bands:int = 5;
        r.height /= bands;
        var alpha:Number = 1;
        var step:Number = -1 / bands;
        for (var band:int = 0; band < bands; band++) {
            var black:RGBA = RGBA.black(alpha);
            var white:RGBA = RGBA.white(alpha);
            var colors:Array = [black, white];
            for (var i:int = 0; i < 8; i++) {
                colors.push(RGBA.random(alpha));
            }
            drawColors(colors, r);
            r.y += r.height;
            alpha += step;
        }
    }

    private function testHSV(r:Rectangle):void {
        var bands:int = 3;
        r.height /= bands;
        var sat:Number = 0.33;
        for (var band:int = 0; band < bands; band++) {
            var colors:Array = new Array();
            var step:int = 30;
            for (var hue:int = 0; hue < 360; hue += step) {
                colors.push(new HSV(hue, sat, 1));
            }
            drawColors(colors, r);
            r.y += r.height;
            sat += .33;
        }
    }
}
}
