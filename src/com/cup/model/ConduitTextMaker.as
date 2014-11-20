package com.cup.model
{
	import com.fonts.ConduitBold;
	import com.fonts.ConduitMedium;
	import com.shashi.model.TextMaker;
	
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class ConduitTextMaker extends TextMaker
	{
		public static const boldConduit:ConduitBold = new ConduitBold();
		public static const mediumConduit:ConduitMedium = new ConduitMedium();
		
		public function ConduitTextMaker()
		{
			super();
		}
		
		public static function createConduitTextField(size:int, bold:Boolean=true, color:uint=0xFFFFFF, leading:int=0):TextField
		{
			var text:TextField = new TextField();
			var newFormat:TextFormat = new TextFormat(bold ? boldConduit.fontName : mediumConduit.fontName, size, color, bold, null, null, null, null, TextFieldAutoSize.LEFT, null, null, null, leading);
			text.embedFonts = true;
			text.defaultTextFormat = newFormat;
			// text.autoSize = TextFieldAutoSize.LEFT;
			
			text.selectable = text.mouseEnabled = false;
			
			return text;
		}
	}
}