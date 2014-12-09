package com.cup.display {
	import com.cup.model.MoneyStr;
	import com.shashi.model.TextMaker;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import gs.TweenLite;
	
	public class RentMarker extends Sprite {
		protected var bgColor:uint = 0x666666;	// not the right light blue
		protected var _rent:int = 0;
		
		protected var label:TextField;
		protected var subLabel:TextField;
		
		public function RentMarker(rentAmount:int, percent:Number, labelText:String) {
			super();
			
			label = TextMaker.createTextField(18);
			addChild(label);
			
			subLabel = TextMaker.createTextField(14);
			subLabel.text = labelText;
			addChild(subLabel);
			
			rent = rentAmount;
			
			scaleX = scaleY = 1;
			
			useHandCursor = buttonMode = true;
		}
		
		public function get bdr():String {
			return subLabel.text;
		}
		
		public function set rent(value:int):void {
			if (_rent != value) {
				_rent = value;
				
				label.text = MoneyStr.toDollarThousands(_rent);
				
				resize();
			}
		}
		
		public function get rent():int {
			return _rent;
		}
		
		public function set background(value:uint):void {
			bgColor = value;
			draw(Math.max(label.width, subLabel.width) + 10, 50);
		}
		
		public function get background():uint {
			return bgColor;
		}
		
		protected function onOver(event:MouseEvent):void {
			TweenLite.to(this, .2, {scaleX: 1, scaleY: 1});
		}
		
		protected function onOut(event:MouseEvent):void {
			TweenLite.to(this, .2, {scaleX: .7, scaleY: .7});
		}
		
		protected function draw(w:Number, h:Number):void {
			var pw:int = w / 2;
			var ph:int = 28;
			with (this.graphics) {
				clear();
				beginFill(bgColor);
				drawRect(-w / 2, 0, w, h);
				moveTo(-pw, 0);
				lineTo(pw, 0);
				lineTo(0, -ph);
				lineTo(-pw, 0);
			}
		}
		
		protected function resize():void {
			if (label) {
				label.x = -label.width / 2;
				label.y = subLabel.height;
			}
			
			if (subLabel) {
				subLabel.x = -subLabel.width / 2;
				subLabel.y = 3;
			}
			
			if (label && subLabel) {
				draw(Math.max(label.width, subLabel.width) + 10, 50);
			}
		}
	}
}