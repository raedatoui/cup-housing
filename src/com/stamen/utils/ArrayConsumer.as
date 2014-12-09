package com.stamen.utils {
import flash.display.DisplayObject;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.ProgressEvent;
import flash.utils.getTimer;

/**
 * The ArrayConsumer distributes the processing of an array over
 * multiple frames, pausing until the next frame whenever it hits
 * the designated frame timeout (in milliseconds). This allows for
 * iterations over large arrays (or small arrays, processed with
 * a "heavy" function) without dropping frames.
 */
[Event(type="flash.events.Event", name="complete")]
[Event(type="flash.events.ProgressEvent", name="progress")]
public class ArrayConsumer extends EventDispatcher {
    public var values:Array;
    public var func:Function;
    public var frameTimeout:int = 50;
    public var currentIndex:int = 0;
    public var frameDispatcher:DisplayObject;

    public function ArrayConsumer() {
        super();
    }

    public function consume(values:Array, func:Function, frameDispatcher:DisplayObject):void {
        this.values = values;
        this.func = func;
        this.frameDispatcher = frameDispatcher;

        currentIndex = 0;
        start();
    }

    public function start():void {
        frameDispatcher.addEventListener(Event.ENTER_FRAME, onEnterFrame);
    }

    public function stop():void {
        frameDispatcher.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
    }

    public function reset():void {
        stop();
        currentIndex = 0;
    }

    protected function onEnterFrame(event:Event):void {
        var t:Number = getTimer();
        var consumed:int = 0;
        while (currentIndex < values.length) {
            func(values[currentIndex++]);
            consumed++;
            if ((getTimer() - t) >= frameTimeout) {
                break;
            }
        }
        // trace('* consumed', consumed, 'elements');

        var bytesLoaded:int = Math.min(currentIndex, values.length);
        var bytesTotal:int = values.length;
        dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS, false, false, bytesLoaded, bytesTotal));

        if (currentIndex >= values.length) {
            stop();
            dispatchEvent(new Event(Event.COMPLETE));
        }
    }
}
}