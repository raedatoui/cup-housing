package com.shashi.info {
	import com.cup.model.ConduitTextMaker;
	import com.cup.ui.CloseButton;
	import com.stamen.display.Padding;
	import com.stamen.graphics.color.IColor;
	import com.stamen.ui.BlockSprite;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import gs.TweenLite;
	
	public class TextShield extends Shield {
	    public var padding:Padding = new Padding(40);
	
	    protected var text:TextField;
		protected var close:TextField;
	    protected var bg:BlockSprite;
	    protected var TITLE:String = 'title';
	    protected var DESC:String = 'desc';

	
	    public function TextShield(title:String, desc:String = '', tw:Number = 400, th:Number = 300, tcol:IColor = null, color:IColor = null) {
	        super(color);
	        name = title;
	
	        bg = new BlockSprite(tw, th, tcol);
	        addChild(bg);
	
	        text = ConduitTextMaker.createConduitTextField(34, true, 0xFFFFFF, 5);
	        text.multiline = true;
	        text.wordWrap = true;
	        text.htmlText = desc.toUpperCase();
	        text.height = th;
			text.mouseEnabled = true;
			
	        addChild(text);
			
			close = ConduitTextMaker.createConduitTextField(34, true, 0xFFFFFF, 5, true, true); 
			close.multiline = true;
			close.wordWrap = true;
			close.htmlText = '<a href="#">close</a>';
			close.addEventListener(MouseEvent.CLICK, remove);
			close.mouseEnabled = true;	
				
			addChild(close);
			
			alpha = 0;
	    }

		override public function remove(event:Event = null):void {
			if(event.target != this.text) {
				TweenLite.to(this, .2, {alpha: 0, onComplete: reallyRemove});
				stage.removeEventListener(Event.RESIZE, onResize);
				stage.removeEventListener(MouseEvent.CLICK, remove);
			}
		}
		
	    override protected function onStage(event:Event):void {
	        super.onStage(event);
	
	        TweenLite.to(this, .4, {alpha: 1});
	    }

	    override protected function refresh(event:Event = null):void {
	        super.refresh(event);
	
	        if (!stage)    return;
	
	        var padding:int = 20;
	        var textPadding:int = 250;
	        if (bg) {
	            bg.x = Math.max(0, (stage.stageWidth - bg.width) / 2);
	            bg.y = 0;
	            bg.height = stage.stageHeight;
	        }
	
	        if (text) {
	            text.x = bg.x + textPadding;
	            text.y = bg.y + padding;
	            text.height = bg.height / text.scaleY;
	            text.width = (bg.width - textPadding * 2);
	
	            var i:int = 34;
	            text.setTextFormat(new TextFormat(ConduitTextMaker.boldConduit.fontName, i, 0xFFFFFF, true));
	            while (text.textHeight > bg.height * .9 && i > 5) {
	                text.setTextFormat(new TextFormat(ConduitTextMaker.boldConduit.fontName, --i, 0xFFFFFF, true));
	            }
				trace(i)
				
				if (close) {
					close.x = bg.x + textPadding;
					close.y = text.textHeight * 1.05;
					close.height = bg.height / close.scaleY;
					close.width = (bg.width - textPadding * 2);
					close.setTextFormat(new TextFormat(ConduitTextMaker.boldConduit.fontName, i-3, 0xFFFFFF, true));
				}
	        }

	    }
	
	}
}
