package com.stamen.display
{
    import com.stamen.utils.DisplayObjectUtils;
    import com.stamen.utils.MathUtils;
    
    import flash.display.DisplayObject;
    import flash.geom.Transform;
    
    public dynamic class DisplayState
    {
        public static function from(obj:DisplayObject, props:Array=null):DisplayState
        {
            var state:DisplayState = new DisplayState();
            if (props) state.properties = props;
            state.read(obj);
            return state;
        }
        
        public static function reset(obj:DisplayObject):DisplayState
        {
            var state:DisplayState = from(obj);
            var reset:DisplayState = new DisplayState();
            reset.write(obj);
            return state;
        }
        
        public static function transfer(properties:Array, a:Object, b:Object):uint
        {
            var transferred:uint = 0;
            for each (var prop:String in properties)
            {
                try
                {
                    b[prop] = a[prop];
                }
                catch (e:Error)
                {
                    continue;
                }
                transferred++;
            }
            return transferred;
        }
        
        public static function interpolate(a:DisplayState, b:DisplayState, f:Number, displayObject:DisplayObject=null):DisplayState
        {
            if (f == 0) return a.clone();
            else if (f == 1) return b.clone();
            
            var result:DisplayState = new DisplayState();
            var properties:Array = a.properties.concat();
            if (properties.indexOf('transform') > -1)
            {
                for each (var p:String in ['x', 'y', 'scaleX', 'scaleY'])
                {
                    var i:int = properties.indexOf(p);
                    if (i > -1) properties.splice(i, 1);
                }
            }
            for each (var prop:String in properties)
            {
                switch (prop)
                {
                    case 'transform':
                        result[prop] = DisplayObjectUtils.interpolateTransforms(displayObject, a.transform, b.transform, f);
                        break;
                        
                    default:
                        result[prop] = MathUtils.map(f, 0, 1, a[prop], b[prop]);
                        break;
                }
            }
            result.properties = a.properties.concat();
            return result;
        }
        
        public var x:Number = 0;
        public var y:Number = 0;
        public var scaleX:Number = 1;
        public var scaleY:Number = 1;
        public var width:Number;
        public var height:Number;
        public var rotation:Number = 0;
        public var alpha:Number = 1;
        public var transform:Transform;
        public var properties:Array = ['x', 'y', 'scaleX', 'scaleY', 'rotation'];
        
        public function read(obj:DisplayObject, props:Array=null):uint
        {
            return transfer(props || properties, obj, this);
        }
        
        public function write(obj:DisplayObject, props:Array=null):uint
        {
            return transfer(props || properties, this, obj);
        }
        
        public function clone():DisplayState
        {
            var state:DisplayState = new DisplayState();
            transfer(properties, this, state);
            if (properties) state.properties = properties.concat();
            return state;
        }
        
        public function translate(dx:Number, dy:Number):void
        {
            x += dx;
            y += dy;
        }
        
        public function scale(sx:Number, sy:Number):void
        {
            scaleX *= sx;
            scaleY *= sy;
        }
        
        public function rotate(degrees:Number):void
        {
            rotation += degrees;
        }
    }
}