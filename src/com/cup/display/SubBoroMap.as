package com.cup.display {
	import com.cup.events.AreaEvent;
	import com.modestmaps.geo.Location;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import gs.TweenLite;
	
	public class SubBoroMap extends Sprite {
		public static const CENTER:Location = new Location(40.877562618139384, -74.08355712890625);
		public static const SCALE_FACTOR:Number = 2.8;// 3.398;
		public static const SCALE_FACTOR_Y:Number = 2.8;// 3.398;
		
		protected var container:DisplayObjectContainer;
		protected var clicked:DisplayObject;
		protected var alphaByArea:Dictionary = new Dictionary(true);
		protected var filtersByArea:Dictionary = new Dictionary(true);
		protected var clickedByArea:Dictionary = new Dictionary(true);
		protected var borosByID:Dictionary = new Dictionary(true);
		
		protected var unselectedFilters:Array = [new GlowFilter(0x000000, 1, 4, 4, 2, 1, false, true)];
		protected var selectedFilters:Array = [new DropShadowFilter(4, 45, 0, 1, 10, 10)];
		protected var selectedOverFilters:Array = [new DropShadowFilter(4, 45, 0, 1, 10, 10), new GlowFilter(0xFFFFFF, 1, 4, 4)];
		
		public function SubBoroMap(obj:DisplayObjectContainer) {
			super();
			
			this.name = 'subBoroMap';
			obj.scaleX = SCALE_FACTOR;
			obj.scaleY = SCALE_FACTOR;
			obj.x = -505; // -675;
			obj.y = -148; // -340;
			obj.addEventListener(MouseEvent.MOUSE_OVER, onOver);
			obj.addEventListener(MouseEvent.MOUSE_OUT, onOut);
			obj.addEventListener(MouseEvent.MOUSE_DOWN, onDown);
			obj.addEventListener(MouseEvent.MOUSE_MOVE, onMove);
			
			trace(obj, obj.numChildren);
			var cur:int = obj.numChildren;
			while (cur) {
				cur--;
				var child:DisplayObject = obj.getChildAt(cur);
				child.alpha = .3;
				child.filters = [new GlowFilter(0x000000, 1, 4, 4, 2, 1, false, true)];
				var id:String = getSubBoroFromMovieClip(child as MovieClip);
				clickedByArea[id] = false;
				borosByID[id] = child;
			}
			
			addChild(obj);
			container = obj;
			(container as Sprite).useHandCursor = (container as Sprite).buttonMode = true;
			
			this.mouseEnabled = false;
			
		}
		
		public function findClicked():void {
			this.mouseEnabled = true;
			
			var objects:Array = this.stage.getObjectsUnderPoint(new Point(this.stage.mouseX, this.stage.mouseY));
			for each (var obj:DisplayObject in objects) {
				if (obj.parent is MovieClip) {
					var id:String = getSubBoroFromMovieClip(obj.parent as MovieClip);
					dispatchEvent(new AreaEvent(AreaEvent.CLICKED, id));
					selectByID(id);
				}
			}
		}
		
		public function selectEntireRange(boroID:String):void {
			// entire boroughs are described by the first character
			var inc:int = 0;
			for each (var boro:MovieClip in borosByID) {
				var id:String = getSubBoroFromMovieClip(boro);
				var isBoro:Boolean = (id.charAt(0) == boroID.charAt(0));
				
				clickedByArea[id] = isBoro;
				boro.filters = isBoro ? selectedFilters : unselectedFilters;
				TweenLite.to(boro, .4, {delay: ++inc * .01, alpha: isBoro ? .6 : .3});
			}
		}
		
		public function selectByID(id:String):void {
			for each (var boro:MovieClip in borosByID) {
				TweenLite.to(boro, .2, {alpha: .3});
				boro.filters = unselectedFilters;
				clickedByArea[getSubBoroFromMovieClip(boro)] = false;
			}
			
			if (clicked) {
				clicked = null;
			}
			
			var newBoro:MovieClip = borosByID[id];
			clicked = newBoro;
			
			clickedByArea[id] = !clickedByArea[id];
			
			if (newBoro) {
				outThis(newBoro);
			}
		}
		
		protected function onDown(event:MouseEvent):void {
			// trace((event.target as DisplayObject).parent == container, (event.target as DisplayObject).name);
			dispatchEvent(new MouseEvent(MouseEvent.MOUSE_DOWN, true, false, this.mouseX, this.mouseY, this));
		}
		
		protected function onMove(event:MouseEvent):void {
			var clip:MovieClip = event.target as MovieClip;
			var id:String = getSubBoroFromMovieClip(clip);
			dispatchEvent(new AreaEvent(AreaEvent.MOVED, id));
		}
		
		protected function onOver(event:MouseEvent):void {
			var clip:MovieClip = event.target as MovieClip;
			overThis(clip);
		}
		
		protected function onOut(event:MouseEvent):void {
			var clip:MovieClip = event.target as MovieClip;
			outThis(clip);
		}
		
		protected function outThis(clip:MovieClip):void {
			var isClicked:Boolean = clickedByArea[getSubBoroFromMovieClip(clip)];
			TweenLite.to(clip, .2, {alpha: isClicked ? .6 : .3});
			clip.filters = isClicked ? selectedFilters : unselectedFilters;
			
			dispatchEvent(new MouseEvent(MouseEvent.MOUSE_OUT));
		}
		
		protected function overThis(clip:MovieClip):void {
			var isClicked:Boolean = clickedByArea[getSubBoroFromMovieClip(clip)];
			TweenLite.to(clip, .4, {alpha: isClicked ? .5 : .2});
			clip.filters = selectedOverFilters;
			
			var id:String = getSubBoroFromMovieClip(clip);
			dispatchEvent(new AreaEvent(AreaEvent.MOVED, id));
		}
		
		// off a subboro movieclip
		public function getSubBoroFromMovieClip(shape:MovieClip):String {
			return shape.name.split('_').pop();
		}
	}
}