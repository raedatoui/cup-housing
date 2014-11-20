package com.shashi.model
{
	import com.cup.display.SubBoroMap;
	import com.modestmaps.TweenMap;
	import com.modestmaps.events.MapEvent;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	public class MapSyncer
	{
		protected var sync:DisplayObjectContainer;
		protected var map:TweenMap;
		protected var lastMouse:Point;
		
		public function MapSyncer(map:TweenMap, toSync:DisplayObjectContainer)
		{	
			this.map = map;
			this.map.stage.addEventListener(MouseEvent.MOUSE_DOWN, onDown);
			this.map.addEventListener(MapEvent.START_ZOOMING, onStartZoomed);
			this.map.addEventListener(MapEvent.STOP_ZOOMING, onZoomed);
			sync = toSync;	
		}
		
		protected function onDown(event:MouseEvent):void
		{
			// keep this so it doesn't always trigger through other UI elements
			var target:DisplayObject = (event.target as DisplayObject);
			if (target.parent && target.parent.parent && target.parent.parent == sync)
			{
				map.grid.mousePressed(event);
				lastMouse = map.grid.pmouse;
				
				// add a listener for the release
				map.stage.addEventListener(MouseEvent.MOUSE_UP, onUp);
				sync.mouseChildren = false;
			}
		}
		
		protected function onUp(event:Event):void
		{
			map.stage.removeEventListener(MouseEvent.MOUSE_UP, onUp);
			map.grid.mouseReleased(event);
			
			// release the sync
			sync.mouseChildren = true;
			
			// if the position hasn't changed, it is a click, so run the function on click
			if (lastMouse == map.grid.pmouse)
			{
				// this pans the map to where the user has clicked
				var pt:Point = new Point((event as MouseEvent).stageX, (event as MouseEvent).stageY - 30);
				map.panTo(map.pointLocation(map.globalToLocal(pt), map), true);
				(sync as SubBoroMap).findClicked();
			}
		}
		
		protected function onStartZoomed(event:MapEvent):void
		{
			if (sync is SubBoroMap)	sync.visible = false;
		}
		
		protected function onZoomed(event:MapEvent):void
		{
			if (sync is SubBoroMap)
			{
				sync.visible = true;
				var factor:Number = SubBoroMap.SCALE_FACTOR;
				
				if (map.getZoom() > 12)
					sync.scaleX = sync.scaleY = Math.pow(2, (map.getZoom() - 12));
				else if (map.getZoom() < 12)
					sync.scaleX = sync.scaleY = Math.pow(.5, (12 - map.getZoom()));
				else
					sync.scaleX = sync.scaleY = 1;
			}
		}
		
		protected function adjustLayer(event:MapEvent):void
		{
			trace('adjusting');	
			/* sync.x = map.markerClip.x;
			sync.y = map.markerClip.y; */
		}
		
		protected function adjustLayerPan(event:MouseEvent):void
		{
		}
	}
}