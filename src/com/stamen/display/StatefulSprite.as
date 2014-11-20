package com.stamen.display
{
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import gs.TweenLite;

	/**
	 * 
	 * StatefulSprite simplifies the task of creating simple animated transitions between different states of a Sprite.
	 * 
	 * e.g. you might have 'small' 'medium' and 'large' views.
	 * 
	 * @see ExampleStatefulSprite
	 * 
	 */
	public class StatefulSprite extends Sprite
	{
		public var states:Dictionary = new Dictionary(true);
		public var stateNames:Array = [];
		public var currentState:String;
		
		private var endTweenTimer:uint;
		
		public function addState(name:String, state:Object):void
		{
			states[name] = state;
			stateNames.push(name);
		} 
		
		public function removeState(name:String):void
		{
			states[name] = null;
			stateNames.splice(stateNames.indexOf(name), 1);
		}
		
		public function getNextState():String
		{
			return stateNames[ (stateNames.indexOf(currentState) + 1) % stateNames.length ];
		}
		
		public function getStateNames():Array
		{
			return stateNames.slice();
		}
		
		public function setState(name:String):void
		{
			beginTween(name);
			var state:Object = states[name];
			for (var child:String in state) {
				var params:Object = state[child];
				for (var prop:String in params) {
					this[child][prop] = params[prop];
				}
			}
			currentState = name;
			endTween(name);
		}
		
		public function tweenState(name:String, delay:Number=0.5):void
		{
			beginTween(name);
			var state:Object = states[name];
			for (var child:String in state) {
				var params:Object = state[child];
				TweenLite.to(this[child], delay, params); 
			}
			if (endTweenTimer) clearTimeout(endTweenTimer);
			endTweenTimer = setTimeout(endTween,delay*1000,name);
			currentState = name;
		}
		
		public function beginTween(name:String):void
		{
			// override me
		}
		public function endTween(name:String):void
		{
			// override me
		}
		
	}
}
