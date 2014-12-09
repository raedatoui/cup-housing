package com.shashi.model {
import com.stamen.text.Helvetica;
import com.stamen.text.HelveticaBold;

import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;

public class TextMaker {
    public static const boldFont:HelveticaBold = new HelveticaBold();
    public static const regularFont:Helvetica = new Helvetica();

    public function TextMaker() {
    }

    public static function createTextField(size:int, bold:Boolean = true, color:uint = 0xFFFFFF):TextField {
        var text:TextField = new TextField();
        var newFormat:TextFormat = new TextFormat(bold ? boldFont.fontName : regularFont.fontName, size, color, bold);
        text.embedFonts = true;
        text.defaultTextFormat = newFormat;
        text.autoSize = TextFieldAutoSize.LEFT;

        text.selectable = text.mouseEnabled = false;

        return text;
    }
}
}