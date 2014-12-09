package com.shashi.display {
import com.stamen.ui.tooltip.TooltipProvider;

import flash.display.Sprite;

public class DragRect extends Sprite implements TooltipProvider {
    public var color:uint = 0xFFFFFF;

    protected var _alpha:Number = 1;
    protected var _width:Number = 0;
    protected var _height:Number = 0;

    public function DragRect(w:Number = 0, h:Number = 0, color:uint = 0xFFFFFF) {
        super();

        this.color = color;
        this.mouseChildren = false;

        this.width = w;
        this.height = h;

        draw(w, h);
    }

    public function setColor(col:uint, alpha:Number = 1):void {
        color = col;
        _alpha = alpha;
        draw(_width, _height);
    }

    public function draw(w:Number = 0, h:Number = 0):void {
        with (this.graphics) {
            graphics.clear();
            lineStyle(1, color);
            beginFill(color, _alpha);
            /* moveTo(-4, 0);
             lineTo(w + 4, 0);
             lineTo(w/2, 6);
             lineTo(-4, 0); */
            drawRect(0, 0, w, h);
            lineStyle(1, 0xFFFFFF, .8);
            moveTo(Math.floor(w / 2 - 1.2), h * .3);
            lineTo(Math.floor(w / 2 - 1.2), h * .7);
            moveTo(Math.ceil(w / 2 + 1.2), h * .3);
            lineTo(Math.ceil(w / 2 + 1.2), h * .7);
            lineStyle();
        }
    }

    override public function set width(value:Number):void {
        if (_width != value)
            draw(value, _height);

        _width = value;
    }

    override public function get width():Number {
        return _width;
    }

    override public function set height(value:Number):void {
        if (_height != value)
            draw(_width, value);

        _height = value;
    }

    override public function get height():Number {
        return _height;
    }

    public function getTooltipText():String {
        return 'Drag to change date';
    }
}
}