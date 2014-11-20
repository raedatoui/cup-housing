package com.cup.display
{
	import com.cup.model.MoneyStr;
	import com.shashi.model.TextMaker;
	import com.stamen.ui.tooltip.TooltipBlocker;

	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.AntiAliasType;
	import flash.text.TextField;

	import gs.TweenLite;

	public class MedianIncomeMarker extends Sprite implements TooltipBlocker
	{
		protected var bgColor:uint = 0;
		protected var _income:int = 0;
		protected var _percent:Number = 0;

		protected var label:TextField;

		protected var big:Boolean = false;
		protected var rentText:TextField;

		protected var _width:Number = 0;
		protected var _height:Number = 0;

		protected var sWidth:Number;
		protected var sHeight:Number;
		protected var bWidth:Number;
		protected var bHeight:Number;

		public function MedianIncomeMarker(initIncome:int, percent:Number, labelText:String)
		{
			super();
			_percent = percent;

			label = TextMaker.createTextField(20);
			addChild(label);

			rentText = TextMaker.createTextField(12);
			rentText.multiline = rentText.wordWrap = true;
			rentText.antiAliasType = AntiAliasType.ADVANCED;
			income = initIncome;

			_width = sWidth;
			_height = sHeight;

			scaleX = scaleY = .7;

			draw(_width, _height);

			useHandCursor = buttonMode = true;
			addEventListener(MouseEvent.ROLL_OVER, onOver);
			addEventListener(MouseEvent.ROLL_OUT, onOut);
		}

		public function set income(value:int):void
		{
			if (_income != value)
			{
				_income = value;
				label.text = int(_percent * 100) + '% MFI';

				rentText.htmlText = 'The bar below shows the income categories that the government uses to decide who is eligible for different affordable housing programs. ' +
						'These categories are expressed as percentages of the “median family income.” ' +
						'\n\nThe MFI for a family of four in Greater New York (which includes the City and some of its suburbs) is $76,800 per year.'; //This is ' + int(_percent * 100) + '% of MFI.';

				sWidth = label.width + 10;

				rentText.width = 240;

				sHeight = label.height + 4;
				bWidth = 260;
				bHeight = rentText.textHeight + label.height + 25;

				resize();
			}
		}

		public function get income():int
		{
			return _income;
		}

		override public function set height(value:Number):void
		{
			_height = value;
			draw(_width, _height);
		}

		override public function get height():Number
		{
			return _height;
		}

		override public function set width(value:Number):void
		{
			_width = value;
			draw(_width, _height);
		}

		override public function get width():Number
		{
			return _width;
		}

		public function get size():Point
		{
			return new Point(sWidth, sHeight);
		}

		public function set selected(value:Boolean):void
		{
			big = value;

			if (value)
			{
				label.text = int(_percent * 100) + '% MFI - ' + MoneyStr.to$050s(_income);
				label.x = -label.width/2;
				rentText.alpha = 0;
				rentText.width = bWidth - 20;
				rentText.x = -rentText.textWidth/2;
				rentText.y = -rentText.textHeight - 15;
				addChild(rentText);
				TweenLite.to(rentText, .2, {alpha:1});
				TweenLite.to(label, .2, {y: -bHeight + 5});
				TweenLite.to(this, .2, {height:bHeight, width:bWidth, scaleX:1, scaleY:1});

				if (this.parent)
					this.parent.setChildIndex(this, this.parent.numChildren-1);
			}
			else
			{
				label.text = int(_percent * 100) + '% MFI';
				label.x = -label.width/2;
				TweenLite.to(label, .2, {y: -label.height - 3});
				TweenLite.to(this, .2, {scaleX:.7, scaleY:.7, height:sHeight, width:sWidth});

				if (contains(rentText))	removeChild(rentText);
			}
		}

		public function get selected():Boolean
		{
			return big;
		}

		protected function onOver(event:MouseEvent):void
		{
			TweenLite.to(this, .2, {scaleX:1, scaleY:1});
		}

		protected function onOut(event:MouseEvent):void
		{
			if (!big)
				TweenLite.to(this, .2, {scaleX:.7, scaleY:.7, height:sHeight, width:sWidth});
		}

		public function onClick(event:MouseEvent):void
		{
			selected = !selected;
		}

		protected function draw(w:Number, h:Number):void
		{
			var pw:int = 8;
			var ph:int = 12;
			with (this.graphics)
			{
				clear();
				beginFill(bgColor);
				drawRect(-w/2, -h, w, h);
				moveTo(-pw, 0);
				lineTo(pw, 0);
				lineTo(0, ph);
				lineTo(-pw, 0);
			}
		}

		protected function resize():void
		{
			if (label)
			{
				label.x = -label.width/2;
				label.y = -label.height - 3;
			}

			/* if (label && subLabel)
			{
				draw(Math.max(label.width, subLabel.width) + 10, label.height + 20);
			} */
		}
	}
}