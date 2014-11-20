package com.cup.display
{
	import com.cup.model.MoneyStr;
	import com.shashi.model.TextMaker;
	import com.stamen.graphics.color.IColor;
	import com.stamen.ui.BlockSprite;
	
	import flash.text.TextField;

	public class PropLabelSprite extends BlockSprite
	{
		protected var topLabels:Array = [];
		protected var botLabels:Array = [];
		protected var tick:int = 2;
		protected var interval:Number = .25;
		
		public function PropLabelSprite(incrementTop:int, incrementBottom:int, maxTop:int, maxBot:int, intervalPercent:Number=.25, tickLength:int=0, w:Number=0, h:Number=0, color:IColor=null)
		{
			var ct:int = incrementTop;
			while (ct < maxTop)
			{
				var top:TextField = TextMaker.createTextField(11);
				top.text = MoneyStr.to$$K(ct);
				addChild(top);
				topLabels.push(top);
				
				ct += incrementTop;
			}
			
			var cb:int = incrementBottom;
			while (cb < maxBot)
			{
				var bot:TextField = TextMaker.createTextField(11);
				bot.text = MoneyStr.toDollarThousands(cb);
				addChild(bot);
				botLabels.push(bot);
				
				cb += incrementBottom;
			}
			
			tick = tickLength;
			interval = incrementTop / maxTop;
			
			super(w, h, color);
		}
		
		override protected function draw(color:IColor=null):void
		{
			with (this.graphics)
			{
				clear();
				lineStyle(2, 0xFFFFFF, 1);
				lineTo(width, 0);
				lineStyle();
				
				var cx:Number = interval * width;
				lineStyle(2, 0xFFFFFF, 1);
				for each (var field:TextField in topLabels)
				{
					var bot:TextField = botLabels[topLabels.indexOf(field)];
					
					field.x = cx - field.textWidth/2;
					field.y = -field.height - tick;
					
					bot.x = cx - bot.textWidth/2;
					bot.y = tick;
					
					moveTo(cx, tick);
					lineTo(cx, -tick);
					
					cx += interval * width;
				}
				lineStyle();
			}
		}
		
	}
}