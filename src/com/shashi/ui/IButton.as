package com.shashi.ui
{
	import flash.events.MouseEvent;
	
	public interface IButton
	{
		function set pressed(value:Boolean):void;
		function get pressed():Boolean;
		
		function set text(value:String):void;
		function get text():String;
		
		function get width():Number;
		function get height():Number;
		
		function onOver(event:MouseEvent=null):void;
		function onOut(event:MouseEvent=null):void;
	}
}