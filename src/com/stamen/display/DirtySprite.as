package com.stamen.display
{
    import flash.display.Sprite;
    import flash.events.Event;
    
    public class DirtySprite extends Sprite
    {
        
        public function DirtySprite()
        {
            dirty = true;
        }

        private var _dirty:Boolean = false;
        public function get dirty():Boolean
        {
            return _dirty;        
        }
        
        public function set dirty(value:Boolean):void
        {
            if (value != _dirty)
            {
                trace(name + '.dirty = ' + value);
                // if we're dirty, listen for the render
                if (value)
                {
                    /**
                     * This is where it gets tricky. If we're on the stage we
                     * can invalidate it and listen for an Event.RENDER event.
                     * Otherwise, we need to listen for the Event.ADDED_TO_STAGE
                     * event, and only when that's fired do we *really* set
                     * _dirty to true and listen for the render.
                     */ 
                    if (stage)
                    {
                        addEventListener(Event.RENDER, onRender);
                        stage.invalidate();
                    }
                    else
                    {
                        addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
                    }
                }
                // otherwise, remove the listener
                else
                {
                    // no biggie if these weren't registered already 
                    removeEventListener(Event.RENDER, onRender);
                    removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
                }
                _dirty = value;
            }
        }
        
        private function onAddedToStage(event:Event):void
        {
            addEventListener(Event.RENDER, onRender);
            stage.invalidate();
        }
        
        private function onRender(event:Event):void
        {
            if (_dirty)
            {
                render();
                _dirty = false;
                removeEventListener(Event.RENDER, onRender);
            }
        }
        
        protected function render():void
        {
        }
    }
}