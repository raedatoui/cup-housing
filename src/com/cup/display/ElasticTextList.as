package com.cup.display
{
	import com.shashi.display.TextList;
	import com.stamen.graphics.color.IColor;
	
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;

	public class ElasticTextList extends TextList
	{
		protected var minWidth:Number = 0;
		protected var minHeight:Number = 0;
		
		public function ElasticTextList(w:Number=0, h:Number=0, color:IColor=null)
		{
			minHeight = h;
			minWidth = w;
			
			super(w, h, color);
		}
		
		override public function updateTextByName(name:String, newText:String, isHTML:Boolean=false):void
		{
			if (lineNames.indexOf(name) >= 0)
				updateText(lineNames.indexOf(name), newText, isHTML);
			else
				addLine(name, newText);
				
			refresh();			
		}
		
		override protected function resize():void
		{
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
			
			this.height = Math.max(minHeight, cy + 8);
		}
	}
}