package com.shashi.svg
{
	import com.shashi.display.TextList;
	import com.stamen.graphics.color.IColor;
	
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;

	public class SVGTextList extends TextList implements ISVGExportable
	{
		public function SVGTextList(w:Number=0, h:Number=0, color:IColor=null)
		{
			super(w, h, color);
		}
		
		protected function exportTextField(field:TextField):String
		{
			var boldStr:String = field.defaultTextFormat.bold ? 'font-weight="bold" ' : '';
			var prefix:String = '<textArea font-family="Helvetica" font-size="' + field.defaultTextFormat.size + '" ' +
								 boldStr + 
								'fill="' + SVGConstants.makeHex(uint(field.defaultTextFormat.color)) + '" ';
			var attrs:Array = [];
			attrs.push('x="' + field.x + '"');
			attrs.push('y="' + field.y + '"');
			attrs.push('width="' + field.width + '"');
			attrs.push('height="' + field.height*1.5 + '"');
			
			return prefix + attrs.join(' ') + '>';
		}
		
		public function export():String
		{
			var format:TextFormat;
			var pt:Point = this.localToGlobal(SVGConstants.ORIGIN);
			var output:Array = ['<g transform="scale(' + this.scaleX + ') rotate(' + this.rotation + ' 0 0) translate(' + pt.x + ' ' + pt.y + ')">'];
			
			if (color)
			{
				output.push('<rect x="0" y="0" height="' + height + '" width="' + width + '"  style="fill: ' + SVGConstants.makeHex(color.hex) + '"/>');
			}
			
			for each (var field:TextField in fields)
			{
				var style:String = exportTextField(field);
				output.push(style + field.text + '</textArea>'); 
			}
			
			output.push('</g>');
			return output.join('\n');
		}
		
	}
}