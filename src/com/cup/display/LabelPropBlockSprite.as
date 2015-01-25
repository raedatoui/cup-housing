package com.cup.display {
	import com.shashi.display.TipSprite;
	import com.shashi.model.TextMaker;
	import com.stamen.graphics.color.IColor;
	import com.stamen.ui.BlockSprite;
	import com.stamen.ui.tooltip.TooltipProvider;
	
	import flash.display.Graphics;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	
	public class LabelPropBlockSprite extends ProportionalBlockSprite implements TooltipProvider {
		protected var texts:Array = [];
		protected var popColumns:Array;
		
		public function LabelPropBlockSprite(columns:Array, labels:Array, tips:Array, blockColors:Array, blockPercents:Array, maxPercent:Number = 1, w:Number = 0, h:Number = 0, color:IColor = null) {
			this.popColumns = columns;
			for (var i:int = 0; i < labels.length; i++) {
				var str:String = labels[i];
				if (str.length) {
					var text:TextField = TextMaker.createTextField(12, false);
					text.htmlText = str;
					text.antiAliasType = AntiAliasType.ADVANCED;
					text.multiline = text.wordWrap = true;
					text.mouseEnabled = text.selectable = false;
					texts.push(text);
					addChild(text);
				}
			}
			
			super(blockColors, blockPercents, maxPercent, w, h, color);
			
			for (i = 0; i < colors.length; i++) {
				var block:TipSprite = blocks[i];
				block.setTooltipText(tips[i]);
			}
		}
		
		override protected function drawThis(g:Graphics, index:int, cx:Number, cw:Number, col:uint, cy:Number = 0, ch:Number = 0):void {
			super.drawThis(g, index, cx, cw, col, cy, ch);
			
			if (texts[index]) {
				var field:TextField = texts[index] as TextField;
				field.width = cw;
				field.x = cx + 4;
			}
			popColumns[index].x = cx-3;
		}
		
		public function getTooltipText():String {
			for each (var b:BlockSprite in blocks) {
				if (b.hitTestPoint(this.mouseX, this.mouseY)) {
					trace('hit', blocks.indexOf(b));
				}
			}
			
			return 'hekllo';
		}
	}
}