package com.stamen.display
{
    import com.stamen.geom.GeometryUtils;
    import com.stamen.graphics.color.IColor;
    import com.stamen.ui.BlockSprite;
    
    import flash.display.Bitmap;
    import flash.display.DisplayObject;
    import flash.display.Loader;
    import flash.display.Shape;
    import flash.events.*;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.net.URLRequest;
    import flash.system.LoaderContext;

    public class ImageSprite extends BlockSprite
    {
        public var autoResize:Boolean = false;
        public var allowMask:Boolean = false;
        
        public var shrinkWrap:Boolean = true;
        
        protected var imageSize:Point;
        protected var image:DisplayObject;
        protected var imageMask:Shape;
        protected var loader:Loader;
        protected var request:URLRequest;
        protected var padding:Padding;

        protected var _imageBytesLoaded:int = 0;
        protected var _imageBytesTotal:int = 0;
        
        public function ImageSprite(image:Object=null, width:Number=0, height:Number=0, bgColor:IColor=null)
        {
            padding = new Padding(0);
            
            imageMask = new Shape();
            imageMask.graphics.beginFill(0xFF00FF, .5);
            imageMask.graphics.drawRect(0, 0, 10, 10);
            imageMask.graphics.endFill();
            addChild(imageMask);
            mask = imageMask;

            if (image is DisplayObject)
            {
                this.image = image as DisplayObject;
                addChild(this.image);
            }
            else if (image)
            {
                load(image);
            }

            super(width, height, bgColor);
        }
        
        public function load(url:*, context:LoaderContext=null):void
        {
            if (url is String)
            {
                request = new URLRequest(url);
            }
            else if (url is URLRequest)
            {
                request = url as URLRequest;
            }
            else
            {
                throw new Error("load() takes a string or URLRequest instance");
            }
            
            unload();
            
            if (!loader)
            {
                loader = new Loader();
                loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onImageLoaded);
                loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onLoadProgress);
                loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onImageLoadError);
                // trace('+ created loader');
            }
            
           	loader.load(request, context ? context : new LoaderContext(true));
        }
        
        public function unload():void
        {
            if (loader)
            {
                try { loader.close(); } catch (e:Error) { }
                try
                {
                    // this is a Flash 9-compatible hack that calls FP 10's Loader.unloadAndStop(gc:Boolean=true)
                    if (loader.hasOwnProperty('unloadAndStop'))
                    {
                        loader['unloadAndStop'](true);
                    }
                    else
                    {
                        loader.unload();
                    }
                }
                catch (e:Error)
                {
                }

                if (contains(loader))
                    removeChild(loader);

                loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onImageLoaded);
                loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, onLoadProgress);
                loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onImageLoadError);
                loader = null;
                // trace('- removed loader');
            }
            if (image && contains(image))
                removeChild(image);
            image = null;
            imageSize = null;
        }
        
        protected function onImageLoaded(event:Event):void
        {
            if (image)
            {
                if (contains(image)) removeChild(image);
                image = null;
            }
            image = loader;
            if (loader.content is Bitmap)
            {
                try
                {
                    (loader.content as Bitmap).smoothing = true;
                }
                catch (e:Error) { /* not a fatal error */ }
            }
            
            resize();
            dispatchEvent(new Event(Event.COMPLETE));
        }
        
        public function get imageWidth():Number
        {
            return imageSize ? imageSize.x : 0;
        }
        
        public function get imageHeight():Number
        {
            return imageSize ? imageSize.y : 0;
        }
        
        protected function updateImage(mask:Rectangle=null):void
        {
            if (!contains(image))
            {
                try
                {
                    addChildAt(image, 0);
                }
                catch (e:Error)
                {
                }
            }

            if (!mask) mask = new Rectangle(0, 0, width, height);
            image.scaleX = image.scaleY = 1;
            
            if (image is Loader && (image as Loader).content.hasOwnProperty('setSize'))
            {
                try
                {
                    ((image as Loader).content as Object).setSize(width, height);
                    return;
                }
                catch (e:Error)
                {
                    trace('unable to setSize() on content:', e.message);
                }
            }
            
            imageSize = new Point(image.width, image.height);
            
            // no resizing necessary
            if (image.width == mask.width && image.height == mask.height) return;
            
            if (autoResize)
            {
                var bounds:Rectangle = mask.clone();
                var imageRect:Rectangle = image.getRect(this);
                var rect:Rectangle;

                if (image.width > width || image.height > height)
                {
                    rect = allowMask
                           ? GeometryUtils.fitRectToMask(imageRect, bounds)
                           : GeometryUtils.constrainRectToBounds(imageRect, bounds);
                    rect.width = Math.round(rect.width);
                    rect.height = Math.round(rect.height);

                    if (shrinkWrap && (imageRect.width < mask.width || imageRect.height < mask.height))
                    {
                        _width = Math.min(mask.width, imageRect.width);
                        _height = Math.min(mask.height, imageRect.height);
                        dispatchEvent(new Event(Event.RESIZE, false));
                    }
                }
                else
                {
                    rect = GeometryUtils.fitRectToMask(imageRect, bounds);
                    rect.width = Math.round(rect.width);
                    rect.height = Math.round(rect.height);
                }
                image.width = rect.width;
                image.height = rect.height;
            }
        }
        
        override protected function resize():void
        {
            var rect:Rectangle = new Rectangle(0, 0, width, height);
            if (padding) padding.deflateRect(rect);
            
            imageMask.width = rect.width;
            imageMask.height = rect.height;
            imageMask.x = rect.x;
            imageMask.y = rect.y;

            if (image)
            {
                updateImage(rect);
                image.x = (width - image.width) / 2;
                image.y = (height - image.height) / 2;
            }

            super.resize();
        }

        protected function onLoadProgress(event:ProgressEvent):void
        {
            _imageBytesLoaded = event.bytesLoaded;
            _imageBytesTotal = event.bytesTotal;
            dispatchEvent(event);
        }
        
        public function get imageBytesLoaded():int
        {
            return _imageBytesLoaded;
        }
        
        public function get imageBytesTotal():int
        {
            return _imageBytesTotal;
        }
        
        override public function getRect(targetCoordinateSpace:DisplayObject):Rectangle
        {
            return imageMask.getRect(targetCoordinateSpace);
        }
        
        override public function getBounds(targetCoordinateSpace:DisplayObject):Rectangle
        {
            return getRect(targetCoordinateSpace);
        }
        
        protected function onImageLoadError(event:ErrorEvent):void
        {
            trace('*** error loading image: "' + request.url + '"');
        }
    }
}