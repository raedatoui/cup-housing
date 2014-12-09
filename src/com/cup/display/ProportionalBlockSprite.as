package com.cup.display {
	import com.shashi.display.TipSprite;
	import com.stamen.graphics.color.IColor;
	import com.stamen.graphics.color.RGB;
	import com.stamen.ui.BlockSprite;
	
	import flash.display.Graphics;
	
	public class ProportionalBlockSprite extends BlockSprite {
		protected var blocks:Array = [];
		
		protected var colors:Array;
		protected var percents:Array;
		protected var max:Number = 1;
		
		public function ProportionalBlockSprite(blockColors:Array, blockPercents:Array, maxPercent:Number = 1, w:Number = 0, h:Number = 0, color:IColor = null) {
			this.colors = blockColors;
			this.percents = blockPercents;
			this.max = maxPercent;
			
			for (var i:int = 0; i < colors.length; i++) {
				var block:TipSprite = new TipSprite(10, h, RGB.fromHex(colors[i]));
				addChildAt(block, 0);
				blocks.push(block);
			}
			
			super(w, h, color);
		}
		
		override protected function draw(color:IColor = null):void {
			var cx:Number = 0;
			graphics.clear();
			
			for (var i:int = 0; i < colors.length; i++) {
				var col:uint = (i < colors.length) ? colors[i] : RGB.black().hex;
				drawThis(this.graphics, i, getX(i), getX(i + 1) - getX(i), col);
			}
		}
		
		protected function drawThis(g:Graphics, index:int, cx:Number, cw:Number, col:uint, cy:Number = 0, ch:Number = 0):void {
			if (!ch)    ch = height;
			
			if (blocks[index]) {
				var block:BlockSprite = blocks[index];
				block.x = cx;
				block.y = cy;
				block.width = cw;
				block.height = ch;
			}
		}
		
		protected function getX(index:int):Number {
			return (percents[index] / max) * width;
		}
	}
}