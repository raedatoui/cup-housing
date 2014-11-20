package com.shashi.ui
{
	import com.stamen.logic.FALSE;
	import com.stamen.ui.tooltip.TooltipProvider;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class BitmapButton extends Sprite implements TooltipProvider
	{
		protected var out:Bitmap;
		protected var over:Bitmap;
		protected var pressed:Bitmap;
		protected var pressedOver:Bitmap;
		
		protected var tip:String = '';
		protected var clicked:Boolean=false;
		
		public function BitmapButton(normal:Bitmap, hover:Bitmap=null, clicked:Bitmap=null, clickedHover:Bitmap=null, tooltip:String='')
		{
			super();
			
			if (normal) 		this.out = normal;
			if (hover)			this.over = hover;
			if (clicked)		this.pressed = clicked;
			if (clickedHover)	this.pressedOver = clickedHover;
			
			if (tooltip)		this.tip = tooltip;
			
			add(out);
			
			if (hover || clickedHover)
			{
				addEventListener(MouseEvent.MOUSE_OVER, onOver);
				addEventListener(MouseEvent.MOUSE_OUT, onOut);
			}
			
			if (pressed && pressedOver)
				addEventListener(MouseEvent.CLICK, onClick);
		}
		
		protected function onOver(event:Event):void
		{
			remove( clicked ? pressed : out );
			
			add( clicked ? pressedOver : over );
		}
		
		protected function onOut(event:Event):void
		{
			remove( clicked ? pressedOver : over );
			
			add( clicked ? pressed : out );
		}
		
		protected function onClick(event:Event):void
		{
			// remove both states in case
			remove( clicked ? pressedOver : over );
			remove( clicked ? pressed : out );
			
			clicked = !clicked;
			
			add( clicked ? pressedOver : over );
		}
		
		protected function add(obj:DisplayObject):void
		{
			if (obj && !contains(obj))	addChild(obj);
		}
		
		protected function remove(obj:DisplayObject):void
		{
			if (obj && contains(obj))	removeChild(obj);
		}
		
		public function getTooltipText():String
		{
			return tip;
		}
	}
}