package com.shashi.display
{
	import com.shashi.model.TextMaker;
	import com.stamen.display.Padding;
	import com.stamen.graphics.color.IColor;
	import com.stamen.ui.BlockSprite;
	
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class TextList extends BlockSprite
	{
		public var autoSize:String = TextFieldAutoSize.CENTER;
		public var padding:Padding = new Padding(4);
		
		public var spacing:int = 0;
		protected var maxWidth:Number = 0;
		
		protected var lineNames:Array = [];
		protected var lines:Array = [];
		protected var fields:Array = [];
		
		public function TextList(w:Number=0, h:Number=0, color:IColor=null)
		{
			super(w, h, color);
		}
		
		public function addLine(name:String, line:String, size:int=14, bold:Boolean=true, color:uint=0xFFFFFF, isHTML:Boolean=false, isMultiline:Boolean=false):void
		{
			lines.push(line);
			
			var newLine:TextField = TextMaker.createTextField(size, bold, color);
			newLine.antiAliasType = AntiAliasType.ADVANCED;
			
			if (isMultiline)
			{
				// newLine.autoSize = TextFieldAutoSize.NONE;
				newLine.multiline = true;
				newLine.wordWrap = true;
			}
			
			if (isHTML)
				newLine.htmlText = line;
			else
				newLine.text = line;
			
			newLine.width = getTextWidth();
			if (newLine.width > maxWidth)	maxWidth = newLine.width;
			
			addChild(newLine);
			lineNames.push(name);
			fields.push(newLine);
			
			resize();
		}
		
		public function getLineByName(name:String):String
		{
			if (lineNames.indexOf(name) >= 0)
				return lines[lineNames.indexOf(name)];
			else
				return '';
		}
		
		public function getFieldByName(name:String):TextField
		{
			if (lineNames.indexOf(name) >= 0)
				return fields[lineNames.indexOf(name)];
			else
				return null;
		}
		
		public function getMaxWidth():Number
		{
			return maxWidth;
		}
		
		public function getTextWidth():Number
		{
			return _width - padding.right - padding.left;
		}
		
		public function updateTextByName(name:String, newText:String, isHTML:Boolean=false):void
		{
			if (lineNames.indexOf(name) >= 0)
				updateText(lineNames.indexOf(name), newText, isHTML);
			else
				addLine(name, newText);			
		}
		
		public function updateText(lineIndex:int, str:String, isHTML:Boolean=false):void
		{
			lines[lineIndex] = str;
			
			var field:TextField = fields[lineIndex];
			
			if (isHTML)		
				field.htmlText = str;
			else
				field.text = str;
		}
		
		public function updateLineByName(name:String, newText:String, size:int=14, bold:Boolean=true, color:uint=0xFFFFFF, isHTML:Boolean=false):void
		{
			if (lineNames.indexOf(name) >= 0)
				updateLine(lineNames.indexOf(name), newText, size, bold, color, isHTML);
			else
				addLine(name, newText, size, bold, color, isHTML);
		}	
		
		public function updateLine(lineIndex:int, str:String, size:int=14, bold:Boolean=true, color:uint=0xFFFFFF, forceRefresh:Boolean=false, isHTML:Boolean=false):void
		{
			lines[lineIndex] = str;
			
			var field:TextField = fields[lineIndex];
			
			// for now just replace it
			if (size > 4)
			{
				field.defaultTextFormat = new TextFormat(TextMaker.regularFont.fontName, size, color, bold);
				if (isHTML)
					field.htmlText = str;
				else
					field.text = str;			
					
				field.width = getTextWidth();
			}
			else
			{
				field.text = '';
			}
			
			if (field.width > maxWidth)	maxWidth = field.width;
			
			if (forceRefresh)
				resize();
		}
		
		public function refresh():void
		{
			resize();
		}
		
		override protected function resize():void
		{
			super.resize();
			
			var cy:Number = padding.top;
			var cx:Number = padding.left;
			for each (var field:TextField in fields)
			{
				if (autoSize == TextFieldAutoSize.CENTER)
					field.x = (width-field.width)/2;
				else if (autoSize == TextFieldAutoSize.LEFT)
					field.x = cx;
					
				field.y = cy;
				
				cy += spacing + field.textHeight;
			}	
			
			this.height = Math.max(_height, cy + 8);
		}
	}
}