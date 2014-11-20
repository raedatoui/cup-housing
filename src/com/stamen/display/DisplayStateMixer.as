package com.stamen.display
{
    import flash.display.DisplayObject;
    
    public class DisplayStateMixer
    {
        public var target:DisplayObject;
        public var start:DisplayState;
        public var end:DisplayState;
        public var properties:Array;
        
        protected var _mix:Number = -1;
        protected var _current:DisplayState;
        
        public function DisplayStateMixer(target:DisplayObject=null, start:DisplayState=null, end:DisplayState=null)
        {
            this.target = target;
            this.start = start;
            this.end = end;
        }

        public function get mix():Number
        {
            return _mix;
        }
        
        public function set mix(value:Number):void
        {
            _mix = value;
            update();
        }
        
        public function get current():DisplayState
        {
            return _current ? _current.clone() : null;
        }
        
        public function update(...rest):void 
        {
            if (!start && target)
            {
                start = DisplayState.from(target, properties);
            }
            _current = (start && end)
                       ? DisplayState.interpolate(start, end, mix, target)
                       : start
                         ? start.clone()
                         : null;
            if (_current && target)
            {
                _current.write(target, properties);
            }
        }
        
        public function reverse(doUpdate:Boolean=false):void
        {
            var tmp:DisplayState = start ? start.clone() : null;
            start = end ? end.clone() : null;
            end = tmp;
            
            if (doUpdate) update();
        }
    }
}