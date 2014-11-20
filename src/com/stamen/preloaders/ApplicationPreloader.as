package com.stamen.preloaders
{
    import flash.display.BlendMode;
    import flash.display.DisplayObject;
    import flash.display.Graphics;
    import flash.display.MovieClip;
    import flash.display.Shape;
    import flash.display.Sprite;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
    import flash.events.Event;
    import flash.geom.Point;
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
    import flash.text.TextFormat;
    import flash.text.TextFormatAlign;
    import flash.utils.getDefinitionByName;

    /**
     * The ApplicationPreloader class can bootstrap a SWF and provide visual feedback of
     * its load progress. Simply add this meta tag above your main class:
     * 
     * [Frame(factoryClass="com.stamen.preloaders.ApplicationPreloader")]
     * 
     * Or subclass ApplicationPreloader, and provide the path to your class in the
     * factoryClass attribute.
     * 
     * No external library references exist in this class, which minimizes its size--and
     * the amount of time required to download enough of the SWF to display the preloader.
     * Extending classes should also attempt to keep external references to a minimum.
     */
    public class ApplicationPreloader extends MovieClip
    {
        /**
         * this determines whether the preloader automatically removes itself from
         * the display list once it has added the main class instance. If you set this
         * to false, you'll be responsible for removing it manually, a la:
         *
         *      var loader:ApplicationPreloader = stage.getChildAt(stage.numChildren - 1)
         *                                          as ApplicationPreloader;
         *      loader.tearDown();
         */
        public var autoTearDown:Boolean = true;
        public var loadingTextPrefix:String = 'Loading... ';
        public var showPercentLoaded:Boolean = true;
        
        /**
         * The name of the class to instantiate when we're done loading. If this isn't
         * set, it's determined automatically using the SWF's filename. For instance,
         *
         *      path/to/my_fancy_thing.swf
         *
         * is translated into "my_fancy_thing". flash.utils.getDefinitionByName() is
         * used to obtain a reference to the class constructor, an instance of which
         * is created and added to the stage below the preloader.
         */ 
        protected var mainClassName:String;
        
        // the background color of the status display
        protected var statusBgColor:Number;
        // the size of the status display
        protected var statusBgSize:Point;
        // the color of the status progress bar
        protected var statusBarColor:Number;
        // for formatting the status text
        protected var statusTextFormat:TextFormat;
        
        protected var statusContainer:Sprite;
        protected var statusBg:Shape;
        protected var statusBar:Shape;
        protected var statusField:TextField;

        protected var frameCount:uint;
        protected var progress:Number;

        public function ApplicationPreloader()
        {
            stop();
            
            stage.scaleMode = StageScaleMode.NO_SCALE;
            stage.align = StageAlign.TOP_LEFT;

            frameCount = 0;
            
            statusBgColor = 0x000000;
            if (!statusBgSize) statusBgSize = new Point(128, 32);
            statusBarColor = 0xFFFFFF;
            statusTextFormat = new TextFormat('Verdana', 12, 0xFFFFFF, true);
            statusTextFormat.align = TextFormatAlign.CENTER;

            createChildren();
            
            stage.addEventListener(Event.RESIZE, onStageResize);
            addEventListener(Event.ENTER_FRAME, onEnterFrame);
            addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
            
            onStageResize(null);
            draw();
        }

        protected function createChildren():void
        {
            statusContainer = new Sprite();
            var g:Graphics = statusContainer.graphics;
            g.beginFill(statusBgColor);
            g.drawRect(0, 0, statusBgSize.x, statusBgSize.y);
            g.endFill();
            
            statusField = new TextField();
            statusField.selectable = false;
            statusField.defaultTextFormat = statusTextFormat;
            statusField.autoSize = TextFieldAutoSize.LEFT;
            statusField.text = loadingTextPrefix;
            var actualHeight:Number = statusField.height;
            statusField.y = (statusContainer.height - statusField.height) / 2 - 1;
            statusField.autoSize = TextFieldAutoSize.NONE;
            statusField.height = actualHeight;
            statusField.width = statusContainer.width;
            statusContainer.addChild(statusField);
            addChild(statusContainer);
            
            statusBar = new Shape();
            g = statusBar.graphics;
            g.beginFill(statusBarColor);
            g.drawRect(0, 0, statusBgSize.x, statusBgSize.y);
            g.endFill();
            statusBar.blendMode = BlendMode.DIFFERENCE;
            statusContainer.addChild(statusBar);

            statusContainer.visible = false;
        }

        protected function onEnterFrame(event:Event):void
        {
            frameCount++;

            if (frameCount > 1)
            {
                statusContainer.visible = true;
            }

            progress = root.loaderInfo.bytesLoaded / root.loaderInfo.bytesTotal;
            draw();

            if (framesLoaded == totalFrames)
            {
                removeEventListener(Event.ENTER_FRAME, onEnterFrame);
                nextFrame();
                init();
            }
        }

        protected function draw():void
        {
            statusBar.width = statusBgSize.x * progress;
            statusField.text = loadingTextPrefix;
            if (showPercentLoaded)
            {
                var percentText:String = (progress >= 0)
                                         ? Math.round(progress * 100) + '%'
                                         : '';
                if (percentText) statusField.appendText(percentText);
            }
        }
        
        protected function getMainClassName():String
        {
            var url:String = loaderInfo.loaderURL;
            var dot:int = url.lastIndexOf('.');
            var slash:int = url.lastIndexOf('/');
            return url.substring(slash + 1, dot);
        }
        
        protected function init():void
        {
            if (mainClassName == null)
            {
                mainClassName = getMainClassName();
                trace('ApplicationPreloader: using auto-detected main class name "' + mainClassName + '"');
            }

            if (!mainClassName)
            {
                throw new Error("No mainClassName defined in ApplicationPreloader!");
            }
            
            var mainClass:Class = getDefinitionByName(mainClassName) as Class;
            if (mainClass)
            {
                var application:DisplayObject = new mainClass();
                stage.addChildAt(application, 0);

                if (autoTearDown)
                {
                    tearDown();
                }
            }
            else
            {
                throw new Error("Unable to obtain instance of class: " + mainClassName);
            }
        }

        public function tearDown():void
        {
            parent.removeChild(this);
        }
        
        protected function onStageResize(event:Event):void
        {
            statusContainer.x = Math.round((stage.stageWidth - statusContainer.width) / 2);
            statusContainer.y = Math.round((stage.stageHeight - statusContainer.height) / 2);
        }

        protected function onRemovedFromStage(event:Event):void
        {
            removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
            stage.removeEventListener(Event.RESIZE, onStageResize);
        }
    }
}