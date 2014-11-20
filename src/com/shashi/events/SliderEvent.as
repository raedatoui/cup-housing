package com.shashi.events
{
	import flash.events.Event;

	public class SliderEvent extends Event
	{
		public static const PLAYING:String = 'playing';
		public static const STOPPED:String = 'stopped';
		public static const PLAY_AREA_CHANGED:String = 'playAreaChanged';
		public static const UPDATE_PRIORITIES:String = 'updatePriorities';
		
		public function SliderEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}