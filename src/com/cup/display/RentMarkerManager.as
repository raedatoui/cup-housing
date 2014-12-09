package com.cup.display {
	import com.cup.model.ColorsCUP;
	import com.cup.model.MoneyStr;
	import com.stamen.graphics.color.IColor;
	import com.stamen.graphics.color.RGB;
	import com.stamen.ui.BlockSprite;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.geom.ColorTransform;
	
	import gs.TweenLite;
	
	public class RentMarkerManager extends BlockSprite {
		protected var markers:Array = [];
		protected var max:int = 5500;
		protected var dragging:RentMarker;
		
		protected var pulse:StripeSprite;
		
		protected var selectedTransform:ColorTransform = new ColorTransform(.5, .5, 1);
		protected var nonTransform:ColorTransform = new ColorTransform(.5, .5, .5);
		
		public function RentMarkerManager(w:Number = 0, h:Number = 0, color:IColor = null) {
			super(w, h, RGB.grey(0x22));
			
			pulse = new StripeSprite(0, h, RGB.black());
			pulse.visible = false;
			addChild(pulse);
			
			var i:int = 3;
			while (i) {
				var marker:RentMarker = new RentMarker(i * 900, (i * 900) / max, i + ' BR');
				addMarker(marker);
				i--;
			}
			markers.reverse();
			
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		protected function onAdded(event:Event):void {
			addEventListener(MouseEvent.MOUSE_DOWN, onDown);
		}
		
		public function show():void {
			var d:Number = 1;
			for each (var marker:RentMarker in markers) {
				TweenLite.to(marker, 1, {delay: d, x: getMarkerPosition(marker)});
				d += .2;
			}
		}
		
		public function hide():void {
			
		}
		
		public function addMarker(marker:RentMarker):void {
			addChild(marker);
			markers.push(marker);
		}
		
		public function refresh():void {
			for each (var marker:RentMarker in markers) {
				placeMarker(marker);
			}
		}
		
		public function activePercent():Number {
			if (dragging)
				return dragging.x / this.width;
			else
				return 0;
		}
		
		public function activeRentAmount():int {
			var bed2:RentMarker = markers[1];
			
			if (bed2 && bed2.bdr == '2 BR')
				return bed2.rent;
			
			if (dragging)
				return dragging.rent;
			else
				return -1;
		}
		
		public function get currentBedrooms():String {
			return (dragging) ? dragging.bdr : '';
		}
		
		public function get currentRent():String {
			return (dragging) ? MoneyStr.to$Thousands(dragging.rent) : '';
		}
		
		protected function onDown(event:MouseEvent):void {
			if (!(event.target is RentMarker)) return;
			
			if (dragging) {
				pulse.endScroll();
				dragging.background = 0x666666;
				dragging.filters = [new DropShadowFilter(1, 45, 0, 1, 3, 3, .7, 2)];
				dragging = null;
			}
			
			dragging = event.target as RentMarker;
			dragging.background = ColorsCUP.LIGHTBLUE;
			dragging.filters = [new DropShadowFilter(4, 45, 0, 1, 6, 6, 1, 2)];
			
			setChildIndex(dragging, numChildren - 1);
			
			pulse.startScroll();
			pulse.width = dragging.x;
			dispatchEvent(new Event(Event.CHANGE));
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMove);
			stage.addEventListener(MouseEvent.MOUSE_UP, onUp);
			stage.addEventListener(Event.MOUSE_LEAVE, onUp);
		}
		
		protected function onUp(event:Event):void {
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onUp);
			stage.removeEventListener(Event.MOUSE_LEAVE, onUp);
		}
		
		protected function onMove(event:MouseEvent):void {
			if (!dragging)    return;
			
			// can't drag past markers around it
			var dragIndex:int = markers.indexOf(dragging);
			var right:Number = (dragIndex + 1 < markers.length) ? markers[dragIndex + 1].x - 20 : this.width;
			var left:Number = (dragIndex - 1 >= 0) ? markers[dragIndex - 1].x + 20 : 0;
			
			dragging.x = Math.max(left, Math.min(right, this.mouseX));
			pulse.width = dragging.x;
			
			updateMarker(dragging);
			
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		protected function updateMarker(marker:RentMarker):void {
			marker.rent = (marker.x / this.width) * max;
		}
		
		protected function placeMarker(marker:RentMarker):void {
			marker.x = getMarkerPosition(marker);
		}
		
		protected function getMarkerPosition(marker:RentMarker):Number {
			return (marker.rent / max) * this.width;
		}
		
		override public function set width(value:Number):void {
			super.width = value;
			
			refresh();
			
			if (dragging)
				pulse.width = dragging.x;
		}
	}
}