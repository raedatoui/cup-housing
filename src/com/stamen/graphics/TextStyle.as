package com.stamen.graphics {
import com.stamen.graphics.color.IColor;
import com.stamen.graphics.color.RGB;

import flash.text.*;

public class TextStyle extends TextFormat {
    public var embedFonts:Boolean = false;
    public var antiAliasType:String = AntiAliasType.NORMAL;

    public var borderWidth:Number;
    public var borderColor:IColor;
    public var showBackground:Boolean;
    public var backgroundColor:IColor;

    public var selectable:Boolean = false;
    public var alwaysShowSelection:Boolean = false;

    public static function fromTextFormat(format:TextFormat):TextStyle {
        var style:TextStyle = new TextStyle(format.font, format.size, format.color,
                format.bold, format.italic, format.underline,
                false, format.url, format.target,
                format.align, format.leftMargin, format.rightMargin,
                format.indent, format.leading);
        return style;
    }

    public static function fromTextField(field:TextField, startIndex:int = -1, endIndex:int = -1):TextStyle {
        var format:TextFormat;
        if (startIndex >= 0) {
            format = field.getTextFormat(startIndex, endIndex);
        }
        else {
            format = field.defaultTextFormat;
        }
        var style:TextStyle = TextStyle.fromTextFormat(format);
        style.embedFonts = field.embedFonts;
        style.antiAliasType = field.antiAliasType;
        style.borderWidth = field.border ? 1 : 0;
        style.borderColor = RGB.fromHex(field.borderColor);
        style.selectable = field.selectable;
        style.alwaysShowSelection = field.alwaysShowSelection;
        return style;
    }

    public function TextStyle(font:String = null, size:Object = null, color:Object = null,
                              bold:Object = null, italic:Object = null, underline:Object = null,
                              embedFonts:Boolean = false, url:String = null, target:String = null,
                              align:String = null, leftMargin:Object = null, rightMargin:Object = null,
                              indent:Object = null, leading:Object = null) {
        super(font, size, color, bold, italic, underline,
                url, target, align, leftMargin, rightMargin, indent, leading);
        this.embedFonts = embedFonts;
    }

    public function clone():TextStyle {
        var style:TextStyle = new TextStyle(font, size, color, bold, italic, underline ? true : false,
                embedFonts, url, target, align, leftMargin, rightMargin,
                indent, leading);
        style.antiAliasType = antiAliasType;
        style.borderWidth = borderWidth;
        style.borderColor = borderColor ? borderColor.clone() : null;
        style.showBackground = showBackground;
        style.backgroundColor = backgroundColor ? backgroundColor.clone() : null;
        style.selectable = selectable;
        style.alwaysShowSelection = alwaysShowSelection;
        return style;
    }

    public function apply(field:TextField, beginIndex:int = -1, endIndex:int = -1):void {
        field.setTextFormat(this, beginIndex, endIndex);
    }

    public function applyDefault(field:TextField):void {
        if (!field) return;

        field.defaultTextFormat = this;

        field.border = (borderWidth > 0);
        if (field.border) {
            field.borderColor = borderColor ? borderColor.toHex() : uint(color);
        }
        field.background = showBackground;
        if (field.background && backgroundColor) {
            field.backgroundColor = backgroundColor.toHex();
        }
        field.embedFonts = embedFonts;
        field.alwaysShowSelection = alwaysShowSelection;
        field.selectable = selectable;
        field.text = field.text;
    }

    public function toHTML(text:String):String {
        var out:String = '<font face="' + font + '" color="#' + RGB.fromHex(color).toString() + '" size="' + size + '">';
        if (underline) out += '<u>';
        if (bold) out += '<b>';
        if (url) out += '<a href="' + url + '">';
        out += text;
        if (url) out += '</a>';
        if (bold) out += '</b>';
        if (underline) out += '</u>';
        out += '</font>';
        return out;
    }
}
}