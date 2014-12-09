package com.stamen.graphics {
import com.stamen.graphics.color.IColor;

public class ButtonStyle extends DrawStyle {
    public var textStyle:TextStyle;

    public function ButtonStyle(textStyle:TextStyle = null, fillColor:IColor = null, lineColor:IColor = null) {
        super(fillColor, lineColor);
        if (textStyle) this.textStyle = textStyle.clone();
    }

    override public function clone():DrawStyle {
        var style:ButtonStyle = new ButtonStyle();
        copyProperties(style);
        style.textStyle = textStyle ? textStyle.clone() : null;
        return style;
    }
}
}