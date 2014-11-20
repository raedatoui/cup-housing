package com.stamen.display
{
    import com.stamen.graphics.color.IColor;
    import com.stamen.ui.BlockSprite;
    
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
    import flash.events.Event;

    public class ApplicationBase extends BlockSprite
    {
        public static var runningLocally:Boolean = false;
        public static var localPrefix:String = 'file://';
        public static var swfPath:String;
        
        protected var _initialized:Boolean = false;
        
        public function ApplicationBase(color:IColor=null)
        {
            super(0, 0, color);
            
            if (stage)
            {
                onAddedToStage(null);
            }
            else
            {
                addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
            }
        }
        
        public function applyParameters(params:Object):void
        {
            if (!params) return;
            for (var param:String in params)
            {
                applyParameter(param, params[param]);
            }
        }
        
        public function applyParameter(name:String, value:String):Boolean
        {
            return false;
        }
        
        /**
         * This should be overridden.
         */
        protected function createChildren():void
        {
        }
        
        public function get initialized():Boolean
        {
            return _initialized;
        }

        /**
         * This is where your bootstrapping code belongs: loading URLs, etc.
         */
        protected function initialize():void
        {
            _initialized = true;
        }
        
        /**
         * The order of operations here is important, so if you're going to
         * override it, custom code should probably occur after
         * super.onAddedToStage(). applyParameter() should be used to handle
         * external parameters, and createChildren() is where the creation of
         * child display objects should happen. resize() is called immediately
         * aftwards, so if you resize your children in that method everything
         * should be arranged properly at the end of this function.
         */
        protected function onAddedToStage(event:Event):void
        {
            removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
            addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);

            if (initialized)
            {
                stage.addEventListener(Event.RESIZE, onStageResize);
                onStageResize(null);
            }
            else
            {
                var swfURL:String = root.loaderInfo.url;
                if (localPrefix.length > 0)
                {
                    runningLocally = (swfURL.substr(0, localPrefix.length) == localPrefix);
                }
                if (!runningLocally)
                {
                    swfPath = swfURL.substr(0, swfURL.lastIndexOf('/') + 1);
                }
                
                applyParameters(root.loaderInfo.parameters);
                
                adjustStage();
                stage.addEventListener(Event.RESIZE, onStageResize);
    
                createChildren();
                onStageResize(null);
                
                initialize();
            }
        }
        
        protected function onRemovedFromStage(event:Event):void
        {
            removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
            addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
            stage.removeEventListener(Event.RESIZE, onStageResize);
        }
        
        protected function adjustStage():void
        {
            stage.scaleMode = StageScaleMode.NO_SCALE;
            stage.align = StageAlign.TOP_LEFT;
        }
        
        protected function onStageResize(event:Event):void
        {
            setSize(Math.ceil(stage.stageWidth), Math.ceil(stage.stageHeight));
        }
    }
}