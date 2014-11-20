package com.cup.display
{
	import com.shashi.model.NumberFormat;
	import com.shashi.model.TextMaker;
	import com.stamen.graphics.color.IColor;
	import com.stamen.graphics.color.RGB;
	import com.stamen.graphics.color.RGBA;
	import com.stamen.ui.BlockSprite;
	import com.stamen.ui.tooltip.TooltipProvider;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	
	import gs.TweenLite;

	public class PopulationDisplay extends BlockSprite implements TooltipProvider
	{
		public var grain:int;
		public var targetHeight:Number = 0;
		public var percentMFI:Number = 0;
		
		protected var tweenPop:int = 0;
		protected var popLabel:TextField;
		
		protected var displayRange:String;
			
		protected var padding:int = 3;
		protected var pop:int;
		protected var popCol:IColor;
		
		protected var max:int;
		protected var blocks:Array = [];
		
		public function PopulationDisplay(range:String, granularity:int, w:Number=0, h:Number=0, color:IColor=null)
		{
			super(w, h, RGBA.white(0));
			
			popCol = color;
			displayRange = range;
			grain = granularity;
			
			popLabel = TextMaker.createTextField(12, true, 0x000000);
			popLabel.visible = false;
			addChild(popLabel);
			
			addEventListener(MouseEvent.ROLL_OUT, onOut);
			addEventListener(MouseEvent.ROLL_OVER, onOver);
		}
		
		public function set population(value:int):void
		{
			pop = value;
			
			max = pop / grain;
			
			redraw();
		}
		
		public function get population():int
		{
			return pop;
		}
		
		public function getPercentPop(value:Number):int
		{
			return pop * value;
		}
		
		public function set percentInactive(value:Number):void
		{
			var cur:Number = 0;
			var increment:Number = 1 / blocks.length;
			var outCol:RGB = RGB.grey(0x66);
			for each (var block:PopBlock in blocks)
			{
				cur += increment;
				
				var show:Boolean = (cur > value);
				block.blockColor = show ? popCol : outCol;
				TweenLite.killTweensOf(block);
				TweenLite.to(block, .2, {rotation:show ? 0 : 45, scaleX:show ? 1 : .5, scaleY:show ? 1 : .5});
			}
		}
		
		public function set labelPopulation(value:int):void
		{
			tweenPop = value;
			popLabel.text = NumberFormat.addCommas(value) + ' families';
			popLabel.y = height - popLabel.height;
			popLabel.x = (width - popLabel.width)/2;
		}
		
		public function get labelPopulation():int
		{
			return tweenPop;
		}
		
		protected function redraw(animate:Boolean=true):void
		{
			var delay:Number = 0;
			while (blocks.length > max)
			{
				kill(blocks.pop(), delay);
				delay += .01;
			}
			
			var cx:int = padding;
			var cy:int = -8 - padding;
			var block:PopBlock;
			var increasing:Number = 0;
			
			for (var i:int=0; i < max; i++)
			{
				if (blocks[i])
				{
					block = blocks[i];
					TweenLite.killTweensOf(block);
					block.alpha = 1;
					block.x = cx;
					block.y = cy;
					block.rotation = 0;
					block.scaleX = block.scaleY = 1;
					block.blockColor = popCol;
					// TweenLite.to(block, Math.random() * .5, {delay:Math.random()*.2, alpha:1});
				}
				else
				{
					block = make();
					block.x = cx;
					block.y = cy - 100;
					TweenLite.killTweensOf(block);
					TweenLite.to(block, Math.random() * .5, {delay:Math.random()*.1 + increasing, alpha:1, y:cy});
					blocks[i] = block;
					addChild(block);
					increasing += .01;
				}
				
				cx += block.width + 2;
				
				if (cx > width - block.width - padding)
				{
					cy -= block.height + 2;
					cx = padding;
				}
				
			}
			
			targetHeight = cy - padding;
			TweenLite.to(this, 1, {height:targetHeight, labelPopulation:population});
		}
		
		protected function onOver(event:MouseEvent):void
		{
			color = RGBA.white(1);
			filters = [new GlowFilter(0, .4)];
		}
		
		protected function onOut(event:MouseEvent):void
		{
			color = RGBA.white(0);
			filters = [];
		}
		
		protected function make():PopBlock
		{
			var pop:PopBlock = new PopBlock(8, 8, popCol);
			pop.alpha = 0;
			return pop;
		}
		
		protected function kill(obj:DisplayObject, delay:Number=0):void
		{
			TweenLite.killTweensOf(obj, true);
			TweenLite.to(obj, Math.random() * .5, {delay:Math.random()*.1 + delay, alpha:0, y:"-50", onComplete:remove, onCompleteParams:[obj]});
		}
		
		protected function remove(obj:DisplayObject):void
		{
			if (this.contains(obj))	this.removeChild(obj);
			
			obj = null;
		}
		
		public function getTooltipText():String
		{
			if (pop)
				return NumberFormat.addCommas(pop) + ' families';
			else
				return displayRange;
		}
		
	}
}