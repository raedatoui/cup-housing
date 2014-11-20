package com.shashi.ui
{
	import com.stamen.graphics.color.RGB;
	import com.stamen.ui.BlockSprite;
	import com.stamen.ui.tooltip.TooltipBlocker;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.setTimeout;

	public class TextDropdown extends Sprite implements TooltipBlocker
	{
		public static const REMOVABLE:String = 'removableButton';
		public static const SELECTABLE:String = 'selectable';
		
		protected var items:Array = [];
		protected var pressedItems:Array = [];
		
		protected var collapsedItem:IButton;
		protected var focusedItem:IButton;
		
		protected var show:DropdownButton;
		protected var drop:Sprite;
		
		protected var type:String;
		
		public function TextDropdown(initText:String, initType:String='', w:Number=250)
		{
			super();
			
			type = initType;
			
			show = new DropdownButton(initText, '', w, 12, 0xFFFFFF, true, 0x666666);
			addChild(show);			
			
			drop = new Sprite();
			drop.visible = false;
			drop.y = show.height;
			addChildAt(drop, 0);
			
			var masker:BlockSprite = new BlockSprite(w, 500, RGB.black());
			masker.y = show.height;
			addChild(masker);
			drop.mask = masker;
			
			resize();
			
			this.addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		override public function get height():Number
		{
			return show.height;
		}
		
		protected function onAdded(event:Event):void
		{
			drop.addEventListener(MouseEvent.CLICK, onClick);
			allowShow();
		}
		
		protected function onShow(event:MouseEvent):void
		{			
			if (event.target is UIButton)	return;
			
			drop.visible = true;
			
			// sync added states
			if (focusedItem && focusedItem is DropdownButton)
			{
				(focusedItem as DropdownButton).added = show.added;
				resetPressedItems();
			}
			
			stage.addEventListener(MouseEvent.MOUSE_UP, onClose);
			show.removeEventListener(MouseEvent.CLICK, onShow);
			show.addEventListener(MouseEvent.CLICK, onClose);
			drop.addEventListener(MouseEvent.MOUSE_MOVE, onMove);
			
			
			resize();
		}
		
		protected function allowShow():void
		{
			show.addEventListener(MouseEvent.CLICK, onShow);
		}
		
		protected function onClose(event:Event=null):void 
		{			
			if (event.target is UIButton)	return;
			
			trace('closing');
			stage.removeEventListener(MouseEvent.MOUSE_UP, onClose);
			show.removeEventListener(MouseEvent.CLICK, onClose);
			
			drop.visible = false;
			
			// delay or it gets caught
			setTimeout(allowShow, 100);
		}
		
		public function setButtons(buttons:Array):void
		{
			for each (var butt:IButton in buttons)
			{
				addButton(butt, false);
			}
			
			resize();
		}
		
		public function addButton(butt:IButton, forceResize:Boolean=true):void
		{
			items.push(butt);
			
			if (butt.pressed)
				pressedItems.push(butt);
			
			drop.addChild((butt as Sprite));
			
			if (forceResize)		
				resize();
		}
		
		public function removeButton(butt:IButton, animate:Boolean=false):void
		{
			if (items.indexOf(butt) < 0)	return;
			
			items.splice(items.indexOf(butt), 1);
			
			if (pressedItems.indexOf(butt) >= 0)
				pressedItems.splice(pressedItems.indexOf(butt), 1);
			
			if (drop.contains(butt as Sprite))	drop.removeChild(butt as Sprite);	
		}
		
		public function set focus(value:IButton):void {
			if (focusedItem)
			{
				if (focusedItem is DropdownButton)
				{
					(focusedItem as DropdownButton).added = show.added;
				}
				focusedItem.pressed = false;
				focusedItem = null;
			}
			
			if (value)
			{
				focusedItem = value;
				focusedItem.pressed = true;
				
				show.addRightType(type);
				if (value is DropdownButton)
				{
					show.added = (value as DropdownButton).added;
				}
				
				// show.text = value.text;
				
				dispatchEvent(new Event(Event.CHANGE));
			} 
		}
		
		public function set selected(value:String):void
		{
			for each (var butt:IButton in items)
			{
				if (butt.text.toLowerCase() == value.toLowerCase())
				{
					focus = butt;
					break;
				}
			}
		}
		
		public function get selected():String
		{
			return focusedItem.text;
		}
		
		public function get pressedButtons():Array
		{
			return pressedItems;
		}
		
		public function addToPressed(value:String):void
		{
			pressedItems.push(value);
		}
		
		public function removeFromPressed(value:String):void
		{
			if (pressedItems.indexOf(value) != -1)
			{
				pressedItems.splice(pressedItems.indexOf(value),1);
			}
		}
		
		protected function onMove(event:MouseEvent):void
		{
			var pos:Number = (this.mouseY - show.height) / 500;
			
			var dest:Number = show.height + -(pos * (drop.height - 500));		
			
//			if (Math.abs(dest - drop.y) > 20)
//				TweenLite.to(drop, .2, {y:dest});
//			else 
			drop.y = dest;	
		}
		
		protected function onClick(event:MouseEvent):void {
			if (event.target is IButton)
			{
				var butt:IButton = event.target as IButton;
				
				// toggle it
				if (!(butt is UIButton))
				{
					if (items.indexOf(butt) >= 0)
						focus = event.target as IButton;
				}
				else
				{
					var addButt:UIButton = butt as UIButton;
					if (addButt.parent is DropdownButton)
					{
						var dropButt:DropdownButton = addButt.parent as DropdownButton;
						
						// add it to the list
						if (addButt.pressed)
							pressedItems.push(dropButt.text);
						else
							pressedItems.splice(pressedItems.indexOf(dropButt.text), 1);
							
						dispatchEvent(new Event(DropdownButton.ADDED));
					}
				}	
			}
		}
		
		protected function resetPressedItems():void
		{
			pressedItems = [];
			for each (var butt:IButton in items)
			{
				var dropButt:DropdownButton = butt as DropdownButton;
				if (dropButt.added)
						pressedItems.push(dropButt.text);
			}
			
			dispatchEvent(new Event(DropdownButton.ADDED));
		}
		
		protected function resize():void
		{
			if (focusedItem)
			{
				(focusedItem as Sprite).y = 0;
				drop.y = focusedItem.height;
			}
			
			if (drop.visible)
			{
				var cy:Number = 0;
				for each (var butt:IButton in items)
				{
					(butt as Sprite).y = cy;
					butt.onOut();
					cy += butt.height;
				}
				
				drop.graphics.clear();
				drop.graphics.beginFill(0x000000, 1);
				drop.graphics.drawRect(0, 0, width, cy);
			}
		}
	}
}