package com.stamen.utils {
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.IEventDispatcher;
import flash.events.ProgressEvent;

[Event(type="flash.events.Event", name="complete")]
[Event(type="flash.events.ProgressEvent", name="progress")]
public class MultiLoader extends EventDispatcher {
    protected var _loaders:Array;
    protected var _loaderProgress:Array;
    protected var _loadersComplete:int;

    public function MultiLoader(loaders:Array = null) {
        super();

        _loaders = new Array();
        _loaderProgress = new Array();
        _loadersComplete = 0;

        if (loaders) {
            loaders.forEach(addLoader);
        }
    }

    public function get numLoaders():int {
        return _loaders.length;
    }

    public function get numLoadersComplete():int {
        return _loadersComplete;
    }

    public function addLoader(loader:IEventDispatcher):Boolean {
        if (_loaders.indexOf(loader) > -1) return false;

        loader.addEventListener(ProgressEvent.PROGRESS, onLoaderProgress);
        loader.addEventListener(Event.COMPLETE, onLoaderComplete);

        _loaders.push(loader);
        _loaderProgress.push(new ProgressEvent(ProgressEvent.PROGRESS, false, false, 0, 0));
        updateProgress();
        return true;
    }

    public function removeLoader(loader:IEventDispatcher):void {
        var index:int = _loaders.indexOf(loader);
        if (index == -1) return;

        var progress:ProgressEvent = _loaderProgress[index] as ProgressEvent;
        if (progress && progress.bytesTotal > 0 && progress.bytesLoaded == progress.bytesTotal) {
            _loadersComplete--;
        }
        loader.removeEventListener(ProgressEvent.PROGRESS, onLoaderProgress);
        loader.removeEventListener(Event.COMPLETE, onLoaderComplete);
        _loaders.splice(index, 1);
        _loaderProgress.splice(index, 1);
        updateProgress();
    }

    public function reset():void {
        for (var i:int = _loaders.length - 1; i >= 0; i--) {
            var loader:IEventDispatcher = _loaders[i] as IEventDispatcher;
            removeLoader(loader);
        }
        _loadersComplete = 0;
        updateProgress();
    }

    protected function onLoaderProgress(event:ProgressEvent):void {
        var loader:IEventDispatcher = event.target as IEventDispatcher;
        var index:int = _loaders.indexOf(loader);
        // trace('... got', event.bytesLoaded, 'bytes loaded @', index);
        _loaderProgress[index] = event;
        updateProgress();
    }

    protected function onLoaderComplete(event:Event):void {
        var loader:IEventDispatcher = event.target as IEventDispatcher;
        var index:int = _loaders.indexOf(loader);
        var oldProgress:ProgressEvent = _loaderProgress[index] as ProgressEvent;
        if (oldProgress.bytesTotal > 0) {
            oldProgress.bytesLoaded = oldProgress.bytesTotal;
        }
        else {
            oldProgress.bytesLoaded = oldProgress.bytesTotal = 1024;
        }
        updateProgress();

        if (++_loadersComplete == _loaders.length) {
            onAllLoadersComplete(event);
        }
    }

    protected function onAllLoadersComplete(event:Event = null):void {
        dispatchEvent(new Event(Event.COMPLETE, false, false));
    }

    protected function updateProgress(event:Event = null):void {
        var bytesLoaded:Number = 0;
        var bytesTotal:Number = 0;
        for (var i:int = 0; i < _loaders.length; i++) {
            var progress:ProgressEvent = _loaderProgress[i] as ProgressEvent;
            if (!isNaN(progress.bytesTotal)) {
                bytesLoaded += progress.bytesLoaded;
                bytesTotal += progress.bytesTotal;
            }
        }
        dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS, false, false, bytesLoaded, bytesTotal));
    }
}
}