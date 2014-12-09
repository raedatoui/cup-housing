package com.cup.events {
	import flash.events.Event;
	
	public class AreaEvent extends Event {
		public static const CLICKED:String = 'clicked';
		public static const MOVED:String = 'moved';
		public var id:String;
		
		public function AreaEvent(type:String, areaID:String, bubbles:Boolean = false, cancelable:Boolean = false) {
			super(type, bubbles, cancelable);
			
			id = areaID;
		}
		
	}
}