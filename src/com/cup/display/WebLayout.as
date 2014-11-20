package com.cup.display
{
	import com.shashi.ui.BitmapButton;
	
	import flash.display.Bitmap;
	import flash.display.BlendMode;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import gs.TweenLite;

	public class WebLayout extends Sprite
	{
		public static const INFO_CLICK:String = 'info';
		public static const INTRO_CLICK:String = 'intro';
		public static const HOME_CLICK:String = 'home';
		public static const GROUPING_CLICK:String = 'change grouping';
		public static const ZOOM_IN_CLICK:String = 'zoom in';
		public static const ZOOM_OUT_CLICK:String = 'zoom out';
		
		[Embed(source='assets/imgs/navigation_01.png')]
		protected var INFO:Class;
		[Embed(source='assets/imgs/navigation_over_01.gif')]
		protected var INFO_OVER:Class;
		
		[Embed(source='assets/imgs//navigation_02.png')]
		protected var GROUPED:Class;
		[Embed(source='assets/imgs/navigation_over_02.gif')]
		protected var GROUPED_OVER:Class;
		[Embed(source='assets/imgs/grouped_expand.gif')]
		protected var EXPAND:Class;
		[Embed(source='assets/imgs/grouped_expand_over.gif')]
		protected var EXPAND_OVER:Class;
		
		[Embed(source='assets/imgs/navigation_03.png')]
		protected var ZOOM_IN:Class;
		[Embed(source='assets/imgs/navigation_over_03.gif')]
		protected var ZOOM_IN_OVER:Class;
		
		[Embed(source='assets/imgs/navigation_04.png')]
		protected var ZOOM_OUT:Class;
		[Embed(source='assets/imgs/navigation_over_04.gif')]
		protected var ZOOM_OUT_OVER:Class;
		
		[Embed(source='assets/imgs/onlinebutton.gif')]
		protected var ONLINE:Class;
		[Embed(source='assets/imgs/onlinebutton_over.gif')]
		protected var ONLINE_OVER:Class;
		
		[Embed(source='assets/imgs/home.png')]
		protected var HOME:Class;
		[Embed(source='assets/imgs/home_over.gif')]
		protected var HOME_OVER:Class;
		
		protected var buttons:Sprite;
		
		public function WebLayout()
		{
			super();
			
			buttons = new Sprite();
			addChild(buttons);
			
			var bit:BitmapButton = new BitmapButton(new HOME(), new HOME_OVER(), null, null, 'Home');
			bit.addEventListener(MouseEvent.CLICK, onHomeClick);
			bit.x = bit.y = 20;
			addChild(bit);
			
			var but:BitmapButton = new BitmapButton(new ONLINE(), new ONLINE_OVER(), null, null, 'Intro Text Again');
			but.addEventListener(MouseEvent.CLICK, onIntro);
			but.x = bit.x;
			but.y = bit.y + bit.height + 8;
			addChild(but);
			
			
			var cont:BitmapButton = new BitmapButton(new INFO(), new INFO_OVER(), null, null, 'More Info');
			cont.addEventListener(MouseEvent.CLICK, onInfo);
			cont.x = bit.x;
			cont.y = but.y + but.height + 8;
			buttons.addChild(cont);
			
			var grouped:BitmapButton = new BitmapButton(new GROUPED(), new GROUPED_OVER(), new EXPAND(), new EXPAND_OVER(), 'Toggle Chart Distribution');
			grouped.addEventListener(MouseEvent.CLICK, onGroupClick);
			grouped.x = cont.x + cont.width;
			grouped.y = cont.y;
			buttons.addChild(grouped);
			
			
			var zoomIn:BitmapButton = new BitmapButton(new ZOOM_IN(), new ZOOM_IN_OVER(), null, null, 'Zoom In');
			zoomIn.addEventListener(MouseEvent.CLICK, onZoomInClick);
			zoomIn.x = grouped.x + grouped.width;
			zoomIn.y = cont.y;
			buttons.addChild(zoomIn);
			
			var zoomOut:BitmapButton = new BitmapButton(new ZOOM_OUT(), new ZOOM_OUT_OVER(), null, null, 'Zoom Out');
			zoomOut.addEventListener(MouseEvent.CLICK, onZoomOutClick);
			zoomOut.x = zoomIn.x + zoomIn.width;
			zoomOut.y = cont.y;
			buttons.addChild(zoomOut);
			
			addEventListener(MouseEvent.MOUSE_OVER, onOver);
			
			this.mouseEnabled = false;
			this.buttonMode = this.useHandCursor = true;
		}
		
		public function loadButtons(event:Event=null):void
		{
			// TweenLite.to(buttons, 1, {alpha:1});
		}
		
		protected function onHomeClick(event:MouseEvent):void
		{
			navigateToURL(new URLRequest('http://envisioningdevelopment.net/'), '_self');
		}
		
		protected function onIntro(event:MouseEvent):void
		{
			dispatchEvent(new Event(INTRO_CLICK));
		}
		
		protected function onInfo(event:MouseEvent):void
		{
			dispatchEvent(new Event(INFO_CLICK));
		}
		
		protected function onGroupClick(event:MouseEvent):void
		{
			dispatchEvent(new Event(GROUPING_CLICK));
		}
		
		protected function onZoomInClick(event:Event):void
		{
			dispatchEvent(new Event(ZOOM_IN_CLICK));
		}
		
		protected function onZoomOutClick(event:Event):void
		{
			dispatchEvent(new Event(ZOOM_OUT_CLICK));
		}
		
		protected function onOver(event:MouseEvent):void
		{
			if (!(event.target is Bitmap))	return; 
			var t:Bitmap = event.target as Bitmap;
			
			if (t is INFO)
			{
				
			}
		}
	}
}