package com.shashi.display {
import com.shashi.model.TextMaker;

import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;

public class HoverLabel extends RoundRect {
    protected var detail:TextField;
    protected var subhead:TextField;

    public function HoverLabel(radius:Number = 0, w:Number = 0, h:Number = 0, textColor:uint = 0x000000, bgColor:uint = 0xDDDDDD, bold:Boolean = true, fontSize:int = 11) {
        super(radius, w, h, bgColor);

        this.color = bgColor;

        _alpha = .5;

        detail = new TextField();
        detail.defaultTextFormat = new TextFormat(TextMaker.regularFont.fontName, fontSize, textColor, bold);
        detail.embedFonts = true;
        detail.selectable = false;
        detail.autoSize = TextFieldAutoSize.LEFT;
        addChild(detail);

        subhead = new TextField();
        subhead.defaultTextFormat = new TextFormat(TextMaker.regularFont.fontName, fontSize - 1, textColor, bold);
        subhead.embedFonts = true;
        subhead.selectable = false;
        subhead.autoSize = TextFieldAutoSize.LEFT;
        subhead.y = detail.height;
        addChild(subhead);

    }

    public function set text(value:String):void {
        detail.text = value;
        detail.x = -detail.width / 2;
        detail.y = -detail.height / 2;

        this.width = detail.width + 10;
        this.height = detail.height + 10;
    }

    public function get text():String {
        return detail.text;
    }

    public function setColorText(value:String, color:Number):void {
        detail.text = value;
        detail.x = 5;
        detail.y = 5;

        subhead.text = 'RGB:' + color.toString(16).toUpperCase();
        subhead.x = 5;
        subhead.y = detail.y + detail.height;

        subhead.textColor = uint(color);

        this.width = Math.max(detail.width, subhead.width) + 10;
        this.height = detail.height + subhead.height + 10;
    }
}
}