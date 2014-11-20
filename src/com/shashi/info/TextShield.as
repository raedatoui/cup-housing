package com.shashi.info
{
	import com.cup.model.ConduitTextMaker;
	import com.stamen.display.Padding;
	import com.stamen.graphics.color.IColor;
	import com.stamen.ui.BlockSprite;
	
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import gs.TweenLite;

	public class TextShield extends Shield
	{
		public var padding:Padding = new Padding(40);
		
		protected var text:TextField;
		protected var bg:BlockSprite;
		protected var TITLE:String = 'title';
		protected var DESC:String = 'desc';
		
		public function TextShield(title:String, desc:String='', tw:Number=400, th:Number=300, tcol:IColor=null, color:IColor=null)
		{
			super(color);
			name = title;
			
			bg = new BlockSprite(tw, th, tcol);
			addChild(bg);
			
			text = ConduitTextMaker.createConduitTextField(34, true, 0xFFFFFF, 5);
			text.multiline = true;
			text.wordWrap = true;
			text.htmlText = desc.toUpperCase();
			// .split('@').join('<').split('#').join('>')
			text.height = th;
			addChild(text);
			
			alpha = 0;
		}
		
		override protected function onStage(event:Event):void
		{
			super.onStage(event);
			
			TweenLite.to(this, .4, {alpha:1});
		}
		
		override protected function refresh(event:Event=null):void
		{
			super.refresh(event);
			
			if (!stage)	return;
			
			var padding:int = 20;
			var textPadding:int = 250;
			if (bg)
			{
				bg.x = Math.max(0, (stage.stageWidth - bg.width)/2);
				bg.y = 0;
				bg.height = stage.stageHeight;
			}
			
			if (text)
			{
				text.x = bg.x + textPadding;
				text.y = bg.y + padding;
				text.height = bg.height / text.scaleY;
				text.width = (bg.width - textPadding*2);
				
				var i:int = 34;
				text.setTextFormat(new TextFormat(ConduitTextMaker.boldConduit.fontName, i, 0xFFFFFF, true));
				while (text.textHeight > bg.height * .95 && i > 5)
				{
					trace(i);
					text.setTextFormat(new TextFormat(ConduitTextMaker.boldConduit.fontName, --i, 0xFFFFFF, true)); 
				}
				
				// text.scaleX = text.scaleY = Math.min(1, (bg.height * .85) / text.textHeight);
				// text.scaleX = text.scaleY = Math.min(1, (bg.height * .85) / text.textHeight);
				
//				if (text.textHeight > bg.height * .85)
//				{
//					trace(text.scaleX);
//					text.width = (bg.width - textPadding*2) / text.scaleX;
//				}
			}
			
		}
		
	}
}