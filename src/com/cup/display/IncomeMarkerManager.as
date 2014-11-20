package com.cup.display
{
	import com.stamen.ui.BlockSprite;

	import flash.events.Event;
	import flash.events.MouseEvent;

	import gs.TweenLite;

	public class IncomeMarkerManager extends BlockSprite
	{
		public var current:MedianIncomeMarker;
		protected var markers:Array = [];

		public function IncomeMarkerManager(w:Number)
		{
			super(w, 0, null);

			addEventListener(MouseEvent.CLICK, onClick);
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}

		protected function onAdded(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);

			// this is so it clears when other things are selected
			// hopefully this makes this class a little more self sufficient
			stage.addEventListener(MouseEvent.CLICK, clear);
		}

		public function addMarker(marker:MedianIncomeMarker):void
		{
			marker.alpha = 0;
			addChild(marker);
			markers.push(marker);
		}

		public function alignWith(percents:Array, maxPercent:Number, sprites:Array, offset:Number, median:int):void
		{
			for each (var sprite:PopulationDisplay in sprites)
			{
				var i:int = sprites.indexOf(sprite);
				var per:Number = percents[i];
				var marker:MedianIncomeMarker = markers[i] as MedianIncomeMarker;

				if (marker)
				{
					tweenTo(marker, (per / maxPercent) * width, sprite.targetHeight + offset);
				}
			}
		}

		public function syncTo(sprites:Array, offset:Number, median:int):void
		{
			for each (var sprite:PopulationDisplay in sprites)
			{
				var marker:MedianIncomeMarker = markers[sprites.indexOf(sprite)] as MedianIncomeMarker;

				var nx:Number = sprite.x;
				if (marker.income == median)
					nx = sprite.x + sprite.width/2;
				else if (marker.income < median)
					nx = sprite.x + sprite.width;
				else if (marker.income > median)
					nx = sprite.x;

				tweenTo(marker, nx, (sprite.targetHeight + offset));
			}
		}

		public function clear(event:Event=null):void
		{
			if (event && event.target == current) return;

			if (current)
				current.selected = false;
		}

		protected function tweenTo(marker:MedianIncomeMarker, nx:Number, ny:Number):void
		{
			var duration:Number = .2;

			if (marker.x == nx)
				duration = Math.abs(marker.y - ny) * .012;

			var delay:Number = 0;
			if (marker.selected)
			{
				marker.selected = false;
				TweenLite.killTweensOf(marker, true);
				marker.width = marker.size.x;
				marker.height = marker.size.y;
				marker.scaleX = marker.scaleY = .7;
				delay = 1;
			}

			TweenLite.to(marker, duration, {delay:delay, alpha:1, x:nx, y:Math.min(-150, ny)});
		}

		protected function onClick(event:MouseEvent):void
		{
			// flip
			if (event.target is MedianIncomeMarker)
			{
				clear(event);

				current = event.target as MedianIncomeMarker;
				current.selected = !current.selected;
			}
		}
	}
}