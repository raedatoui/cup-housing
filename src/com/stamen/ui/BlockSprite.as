package com.stamen.ui {
import com.stamen.display.ColorSprite;
import com.stamen.display.Padding;
import com.stamen.graphics.color.*;

import flash.display.BitmapData;

public class BlockSprite extends ColorSprite {
    public var bitmap:BitmapData;
    public var margin:Padding = new Padding();

    protected var _width:Number;
    protected var _height:Number;
    protected var _roundedness:Number;

    public function BlockSprite(w:Number = 0, h:Number = 0, color:IColor = null) {
        super();
        if (color) _color = color;
        _width = w;
        _height = h;
        resize();
    }

    public function setSize(w:Number, h:Number):Boolean {
        if (w != _width || h != _height) {
            _width = w;
            _height = h;
            resize();
            return true;
        }
        return false;
    }


    public function resize():void {
        draw();
    }

    override public function get width():Number {
        return isNaN(_width) ? super.width : _width;
    }

    override public function get height():Number {
        return isNaN(_height) ? super.height : _height;
    }

    override public function set width(value:Number):void {
        setSize(value, _height);
    }

    override public function set height(value:Number):void {
        setSize(_width, value);
    }

    public function get actualWidth():Number {
        return super.width;
    }

    public function get actualHeight():Number {
        return super.height;
    }

    override protected function updateColor():void {
        draw();
    }

    public function get roundedness():uint {
        return _roundedness;
    }

    public function set roundedness(value:uint):void {
        if (_roundedness != value) {
            _roundedness = value;
            draw();
        }
    }

    protected function draw(color:IColor = null):void {
        if (!color) color = _color;

        var round:Number = roundedness;
        with (graphics) {
            clear();

            if (color || bitmap) {
                if (bitmap) {
                    beginBitmapFill(bitmap);
                }
                else {
                    beginFill(color.toHex(), color.alpha);
                }
                if (!isNaN(round) && round > 0) {
                    drawRoundRect(0, 0, width, height, round, round);
                }
                else {
                    drawRect(0, 0, width, height);
                }
                endFill();
            }
        }
    }
}
}