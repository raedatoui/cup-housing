package com.cup.display
{
	import com.cup.model.MoneyStr;
	import com.cup.model.SubBoroIncomes;
	import com.cup.output.PDFCompositor;
	import com.cup.ui.CloseButton;
	import com.shashi.ui.DropdownButton;
	import com.stamen.graphics.color.IColor;
	import com.stamen.ui.BlockSprite;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextFieldAutoSize;

	public class BoroDisplay extends BlockSprite
	{
		public static const BORO_TOGGLE:String = 'selectWholeBoro';
		public static const RENT_TOGGLE:String = 'rent';
		public static const WHATNOW_TOGGLE:String = 'whatNow';
		public static const CLOSE:String = 'close';
		
		// consts
		protected static const TITLE:String = 'title';
		protected static const SUBTITLE:String = 'subtitle';
		protected static const RENT:String = 'rent';
		protected static const SCALE:String = 'scale';
		
		protected static const SUBBORO:int = 0;
		protected static const BORO:int = 1;
		protected static const CITY:int = 2;
		
		// display
		protected var text:ElasticTextList;
		protected var boroButton:DropdownButton;
		protected var rentButton:DropdownButton;
		protected var printButton:DropdownButton;
		protected var whatNextButton:DropdownButton;
		protected var close:CloseButton;
		
		// data
		protected var data:SubBoroIncomes;
		
		public function BoroDisplay(w:Number=0, h:Number=0, color:IColor=null)
		{
			super(w, h, color);
			
			text = new ElasticTextList(w - 6 - 24, h - 20);
			text.x = 3;
			text.spacing = 15; 
			text.autoSize = TextFieldAutoSize.LEFT;
			text.addLine(TITLE, 'Income Distribution in NYC Sub-Boro Areas', 24, true, 0xFFFFFF, false, true);
			text.addLine(SUBTITLE, '(click on a sub-boro to show the distribution)', 14, false, 0xFFFFFF, false, true);
			text.addLine(RENT, '', 14, false, 0xFFFFFF, false, true);
			text.addLine(SCALE, '', 12, false);
			addChild(text);
			
			printButton = new DropdownButton('Print this!', '', 0, 12, 0xFFFFFF, true, 0x666666);
			printButton.addEventListener(MouseEvent.CLICK, printCurrentSelection);
			addChild(printButton);
			
			rentButton = new DropdownButton('Who can afford to live here?', '', 0, 12, 0xFFFFFF, true, 0x666666);
			rentButton.addEventListener(MouseEvent.CLICK, function(event:Event):void {
				dispatchEvent(new Event(RENT_TOGGLE));
			});
			addChild(rentButton);
			
			boroButton = new DropdownButton('Select the entire borough', '', 0, 12, 0xFFFFFF, true, 0x666666);
			boroButton.addEventListener(MouseEvent.CLICK, function(event:Event):void {
				dispatchEvent(new Event(BORO_TOGGLE));
			});
			addChild(boroButton);
			
			whatNextButton = new DropdownButton('What next?', '', 0, 12, 0xFFFFFF, true, 0x666666);
			whatNextButton.addEventListener(MouseEvent.CLICK, function(event:Event):void {
				dispatchEvent(new Event(WHATNOW_TOGGLE));
			});
			whatNextButton.visible = false;
			addChild(whatNextButton);
			
			close = new CloseButton();
			close.x = w - close.width - 10;
			close.y = 13;
			close.addEventListener(MouseEvent.CLICK, onClick);
			addChild(close);
			
			refresh();
		}
		
		protected function onClick(event:MouseEvent):void
		{
			visible = false;
			dispatchEvent(new Event(CLOSE));
		}
		
		public function set title(value:String):void
		{
			text.updateTextByName(TITLE, value);
		}
		
		public function set subtitle(value:String):void
		{
			text.updateTextByName(SUBTITLE, value, true);
		}
		
		public function set scale(value:int):void
		{
			text.updateTextByName(SCALE, '1 square equals ' + value + ' families.');
		}
		
		public function set rentVisible(value:Boolean):void
		{
			rentButton.text = (!value) ? 'Who can afford to live here?' : 'Hide rent information';
			
			boroButton.visible = !value;
			whatNextButton.visible = value;
		}
		
		public function set rentLabel(value:String):void
		{
			text.updateTextByName(RENT, value, true);
			
			refresh();
		}
		
		public function setBoro(value:SubBoroIncomes, medianFamilyIncome:int=76800, grain:int=100, year:int=2006):void
		{
			if (!value)
			{
				title = '';
				subtitle = '';
				scale = 100;
				data = value;
				
				refresh();
				return;
			}
			
			visible = true;
			
			var dif:Number = int(100 * (value.medianIncome / medianFamilyIncome));
			var difString:String = '<b>' + dif + '%</b> of the citywide median income, ' + MoneyStr.toDollarThousands(medianFamilyIncome) + '.';
			
			var subStr:String = 'The median income here in <b>' + year.toString() + '</b> was <b>' + MoneyStr.toDollarThousands(value.medianIncome) + 
							'</b>.\nThis is ' + difString;
							
			title = value.name.length ? value.name : value.borough;
			subtitle = subStr;
			scale = grain;
			
			boroButton.visible = (value.name.length > 0);
			whatNextButton.visible = !boroButton.visible;
			
			data = value;
			
			text.refresh();
			
			refresh();
		}
		
		public function getCurrentSelection():SubBoroIncomes
		{
			if (!data) return null;
			else	   return data;
		}
		
		public function printCurrentSelection(event:MouseEvent):void
		{
			if (!data)	return;
			
			dispatchEvent(new Event(PDFCompositor.PRINT));
		}
		
		public function onPDFStart():void
		{
			// disable the print button while it's working so that people don't just keep clicking it
			printButton.text = 'Printing';
			printButton.useHandCursor = false;
			printButton.removeEventListener(MouseEvent.CLICK, printCurrentSelection);
		}
		
		public function onPDFComplete(event:Event=null):void
		{			
			printButton.useHandCursor = true;
			printButton.text = 'Print this!';
			printButton.addEventListener(MouseEvent.CLICK, printCurrentSelection);			
		}
		
		protected function refresh(e:Event=null):void
		{
			boroButton.x = 10;
			boroButton.y = text.height;
			
			whatNextButton.x = boroButton.x;
			whatNextButton.y = boroButton.y;
			
			rentButton.x = 10;
			rentButton.y = boroButton.y + boroButton.height + 3;
			
			printButton.x = 10;
			printButton.y = rentButton.y + rentButton.height + 3;			
			
			height = printButton.y + printButton.height + 10;
		}
	}
}