package com.shashi.ui {
import flash.display.CapsStyle;
import flash.display.LineScaleMode;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.geom.ColorTransform;

public class UIButton extends Sprite implements IButton {
    public static const CLOSE:String = 'close';
    public static const ADD:String = 'add';
    public static const PRINT:String = 'print';

    protected var symbolColor:uint;
    protected var type:String;
    protected var size:Number;

    protected var _pressed:Boolean = false;

    protected var outTransform:ColorTransform = new ColorTransform(.5, .5, .5, 1);
    protected var overTransform:ColorTransform = new ColorTransform(1, 1, 1, 1);

    public function UIButton(type:String, shapeCol:uint = 0xFFFFFF, w:Number = 16, h:Number = 16) {
        super();

        this.symbolColor = shapeCol;
        this.size = w;
        this.type = type;
        this.mouseChildren = false;
        this.buttonMode = this.useHandCursor = true;

        draw(symbolColor);

        addEventListener(MouseEvent.MOUSE_OVER, onOver);
        addEventListener(MouseEvent.MOUSE_OUT, onOut);
        addEventListener(MouseEvent.CLICK, onClick);
    }

    protected function draw(color:uint, bg:uint = 0x000000, bgAlpha:Number = 0):void {
        graphics.clear();

        graphics.beginFill(bg, bgAlpha);
        graphics.drawRoundRect(-size / 2, -size / 2, size, size, size / 10);
        graphics.endFill();

        var rad:Number = (size / 2) - 3;
        switch (type) {
            case CLOSE:
                graphics.lineStyle(4, color, 1, false, LineScaleMode.NORMAL, CapsStyle.NONE);
                graphics.moveTo(-rad, rad);
                graphics.lineTo(rad, -rad);
                graphics.moveTo(rad, rad);
                graphics.lineTo(-rad, -rad);
                graphics.lineStyle();
                break;
            case ADD:

                graphics.lineStyle(4, color, 1, false, LineScaleMode.NORMAL, CapsStyle.NONE);
                graphics.moveTo(-rad, 0);
                graphics.lineTo(rad, 0);
                graphics.moveTo(0, rad);
                graphics.lineTo(0, -rad);
                graphics.lineStyle();
                break;
            case PRINT:
                graphics.lineStyle(1, color, 1, false, LineScaleMode.NORMAL, CapsStyle.NONE);
                graphics.drawRect(-(rad / 1.5), -rad, rad * .75, rad);

                graphics.lineStyle(1, color, 1, false, LineScaleMode.NORMAL, CapsStyle.NONE);
                graphics.moveTo(0, rad / 2);
                graphics.lineTo(0, rad / 2);
                graphics.moveTo(rad, -rad / 2);
                graphics.lineTo(-rad, -0);
                graphics.lineStyle();
                break;
        }
    }

    public function set pressed(value:Boolean):void {
        _pressed = value;
        transform.colorTransform = pressed ? overTransform : outTransform;
    }

    public function get pressed():Boolean {
        return _pressed;
    }

    public function set text(value:String):void {
        type = value;

        draw(symbolColor);
    }

    public function get text():String {
        return type;
    }

    public function onOver(event:MouseEvent = null):void {
        draw(symbolColor, 0xFFFFFF, .4);
    }

    public function onOut(event:MouseEvent = null):void {
        draw(symbolColor);
    }

    public function onClick(event:MouseEvent = null):void {
        pressed = !pressed;
    }

}
}