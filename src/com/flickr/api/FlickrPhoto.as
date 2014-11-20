package com.flickr.api
{
    import com.adobe.utils.StringUtil;
    import com.stamen.media.IMedia;
    import com.stamen.media.MediaType;
    import com.stamen.utils.DateUtils;
    
    import flash.events.ErrorEvent;
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.geom.Point;
    import flash.net.URLLoader;
    import flash.net.URLRequest;
    import flash.net.URLVariables;
    import flash.utils.Dictionary;
    
    public class FlickrPhoto implements IMedia
    {
        public static const SMALL:String = 's';
        public static const THUMB:String = 't';
        public static const MEDIUM:String = 'm';
        public static const STANDARD:String = '-';
        public static const LARGE:String = 'b';
        public static const ORIGINAL:String = 'o';
        
        public static const SMALL_SIZE:uint = 75;
        public static const THUMB_SIZE:uint = 100;
        public static const MEDIUM_SIZE:uint = 240;
        public static const STANDARD_SIZE:uint = 500;
        public static const LARGE_SIZE:uint = 1024;
        
        protected var _id:String;
        protected var _title:String;
        protected var _media:String = MediaType.PHOTO;
        protected var _ownerID:String;
        protected var _ownerName:String;
        
        public var taken:Date;
        public var uploaded:Date;
        public var views:uint;
        
        public var latitude:Number;
        public var longitude:Number;
        
        public var secret:String;
        public var originalSecret:String;
        public var originalFormat:String;
        public var originalSize:Point;
        public var farm:String;
        public var server:String;
        
        public var loadedPhotoDimensions:Dictionary = new Dictionary();
        public var loadedPhotoURLs:Dictionary = new Dictionary();
        
        public static function fromXML(xml:XML):FlickrPhoto
        {
            var photo:FlickrPhoto = new FlickrPhoto(xml.@id);
            photo.applyXML(xml);
            return photo;
        }
        
        public static function fromRSS(item:XML):FlickrPhoto
        {
            const flickr:Namespace = new Namespace('urn:flickr:');
            const media:Namespace = new Namespace('http://search.yahoo.com/mrss/');
            
            var photo:FlickrPhoto = new FlickrPhoto();
            photo._title = item.title.text();
            
            var author:XML = item.author[0];
            var ownerHref:String = author.attribute(new QName(flickr, 'profile')).toXMLString();
            var parts:Array;
            /**
             * If we got an author href, it's safe to assume that all of the Flickr and MediaRSS
             * metadata is in there. This is a lot easier to parse than the HTML portion of the
             * <description>.
             */
            if (ownerHref)
            {
                // trace('* Got flickr:profile attribute in <author>, href:', ownerHref);
                parts = parseURL(ownerHref);
    
                photo._ownerID = parts[parts.length - 1];
                photo._ownerName = item.media::credit[0].text();
    
                var imageNodes:Array = [item.media::thumbnail[0], item.media::content[0]];
                for each (var imageNode:XML in imageNodes)
                {
                    photo.applyImageXML(imageNode, 'url');
                }
            }
            else
            {
                // trace('* No Flickr metadata found; falling back on basic RSS');
                var linkHref:String = StringUtil.trim(item.link.text());
                parts = parseURL(linkHref);
                // trace('got link parts:', parts);
                
                var pi:int = parts.indexOf('photos');
                photo._ownerID = parts[pi + 1];
                photo._id = parts[pi + 2];
                
                var content:String = item.description.text().toString();
                if (content.indexOf('rb_attribution') > -1)
                {
                    content = content.substring(0, content.lastIndexOf('<p'));
                }
                // trace('content:', content);
                var desc:XML = new XML('<div>' + content + '</div>');
                photo._ownerName = desc..a[0].text();
                var img:XML = desc..img[0];
                if (img)
                {
                    photo.applyImageXML(img, 'src');
                }
            }
            return photo;
        }
        
        protected static function parseURL(url:String):Array
        {
            var parts:Array = url.split('/').slice(2);
            while (parts.length > 0 && parts[parts.length - 1] == '/')
            {
                parts.pop();
            }
            return parts;
        }
        
        public static function parseDate(str:String):Date
        {
            return DateUtils.parseDateTime(str);
        }
        
        public static function compare(a:FlickrPhoto, b:FlickrPhoto):Boolean
        {
            return a && b && a.id == b.id;
        }
        
        public function FlickrPhoto(id:String=null)
        {
            _id = id;
        }

        public function applyXML(xml:XML):void
        {
            _title = xml.@title;
            _ownerID = xml.@owner;
            _ownerName = xml.@ownername;
            secret = xml.@secret;
            
            if (xml.@longitude)
            {
            	this.longitude = xml.@longitude;
            }
            if (xml.@latitude)
            {
            	this.latitude = xml.@latitude;
            }
            
            if (xml.@media.length() == 1)
            {
                _media = xml.@media;
            }
            
            var taken:String = xml.@datetaken;
            if (taken.length)
            {
                this.taken = parseDate(taken);
            }
            var uploaded:String = xml.@dateuploaded;
            if (uploaded.length)
            {
                this.uploaded = parseDate(uploaded);
            }
            
            var lat:String = xml.@latitude;
            if (lat.length)
            {
                latitude = parseFloat(lat);
                longitude = parseFloat(xml.@longitude);
            }
            
            var viewString:String = xml.@views;
            if (viewString.length)
            {
                views = parseInt(viewString);
            }
            
            originalSecret = xml.@originalsecret;
            if (originalSecret)
            {
                originalFormat = xml.@originalformat;
                var width:Number = parseInt(xml.@o_width);
                if (!isNaN(width))
                {
                    originalSize = new Point(width, parseInt(xml.@o_height));
                }
            }
            
            farm = xml.@farm;
            server = xml.@server;
        }
        
        protected function applyImageXML(img:XML, urlAttr:String):Boolean
        {
            var url:String = img.attribute(urlAttr).toXMLString();
            if (url)
            {
                var parts:Array = parseURL(url);
                
                var hostname:String = parts.shift();
                farm = hostname.substring(4, hostname.indexOf('.'));
                server = parts.shift();
                
                var filename:String = parts.shift();
                parts = filename.split('_');
                _id = parts.shift();
                secret = parts.shift();
                
                var size:String = (parts.length > 0)
                                  ? (parts.shift() as String).substr(0, 1)
                                  : STANDARD;
                loadedPhotoURLs[size] = url;
                loadedPhotoDimensions[size] = new Point(parseInt(img.@width),
                                                        parseInt(img.@height));
                return true;
            }
            
            return false;
        }
        
        public function get id():String
        {
            return _id;
        }
        
        public function get title():String
        {
            return _title;
        }
        
        public function get href():URLRequest
        {
            return new URLRequest('http://flickr.com/photos/' + _ownerID + '/' + id + '/');
        }
        
        public function get media():String
        {
            return _media;
        }
        
        public function get authorName():String
        {
            return _ownerName;
        }
        
        public function get label():String
        {
            return 'photo by ' + authorName + ' on Flickr';
        }
        
        public function getImageURL(size:String=null, ...rest):URLRequest
        {
            if (!size) size = STANDARD;
            if (loadedPhotoURLs[size] != null)
            {
                return new URLRequest(loadedPhotoURLs[size]);
            }
            var format:String = 'jpg';
            var url:String = 'http://farm' + farm + '.static.flickr.com/' + server + '/' + id;
            if (size == ORIGINAL)
            {
                if (!originalSecret)
                {
                    throw new Error("Can't generate an original size URL without an originalSecret!");
                }
                url += '_' + originalSecret + '_o';
                if (originalFormat) format = originalFormat;
            }
            else
            {
                if (!secret)
                {
                    throw new Error("Can't generate an URL without a secret!");
                }
                url += '_' + secret;
                if (size != STANDARD) url += '_' + size;
            }
            return new URLRequest(url + '.' + format);
        }

        public function getVideoURL(autoPlay:Boolean=true):URLRequest
        {
            var request:URLRequest = new URLRequest(FlickrVideo.SWFURL);
            var data:URLVariables = new URLVariables();
            data['v'] = FlickrVideo.defaultVersion;
            data['intl_lang'] = FlickrVideo.defaultLang;
            data['photo_id'] = id;
            data['photo_secret'] = secret;
            // data['flickr_noAutoPlay'] = autoPlay ? 'false' : 'true';
            data['onsite'] = autoPlay.toString();
            request.data = data;
            return request;
        }
        
        public function get aspectRatio():Number
        {
            return originalSize ? (originalSize.x / originalSize.y) : 1;
        }
        
        public function getDimensions(size:String=null, defaultAspectRatio:Number=0):Point
        {
            if (!size) size = STANDARD;
            if (loadedPhotoDimensions[size] is Point)
            {
                return loadedPhotoDimensions[size] as Point;
            }
            
            var width:Number;
            switch (size)
            {
                case SMALL:
                    return new Point(SMALL_SIZE, SMALL_SIZE);

                case ORIGINAL:
                    return originalSize ? originalSize.clone() : null;

                case THUMB:
                    width = THUMB_SIZE;
                    break;
                case MEDIUM:
                    width = MEDIUM_SIZE;
                    break;
                case LARGE:
                    width = LARGE_SIZE;
                    break;
                case STANDARD:
                    width = STANDARD_SIZE;
                    break;
            }
            var aspect:Number = defaultAspectRatio || aspectRatio;
            return new Point(width, width / aspect);
        }
        
        public function get sizesLoaded():Boolean
        {
            return loadedPhotoDimensions[STANDARD] is Point;
        }
        
        public function loadSizes(api:FlickrRESTAPI):URLLoader
        {
            if (sizesLoaded)
            {
                return null;
            }
            
            var request:URLRequest = api.getRequest('photos.getSizes', {photo_id: id});
            var loader:URLLoader = new URLLoader(request);
            loader.addEventListener(Event.COMPLETE, onSizesLoaded);
            loader.addEventListener(IOErrorEvent.IO_ERROR, onSizesLoadError);
            return loader;
        }
        
        protected function onSizesLoaded(event:Event):void
        {
            var loader:URLLoader = event.target as URLLoader;
            loader.removeEventListener(Event.COMPLETE, onSizesLoaded);
            loader.removeEventListener(IOErrorEvent.IO_ERROR, onSizesLoadError);
            var xml:XML = new XML(loader.data);
            
            const sizeMap:Object = {Square:     SMALL,
                                    Thumbnail:  THUMB,
                                    Small:      MEDIUM,
                                    Medium:     STANDARD,
                                    Large:      LARGE,
                                    Original:   ORIGINAL};

            for each (var node:XML in xml..size) 
            {
                var size:String = sizeMap[node.@label.toString()];
                if (size)
                {
                    var width:int = parseInt(node.@width);
                    var height:int = parseInt(node.@height);
                    loadedPhotoDimensions[size] = new Point(width, height);
                    loadedPhotoURLs[size] = node.@source.toString();
                }
            }
        }
        
        protected function onSizesLoadError(event:ErrorEvent):void
        {
            trace('...');
            var loader:URLLoader = event.target as URLLoader;
            loader.removeEventListener(Event.COMPLETE, onSizesLoaded);
            loader.removeEventListener(IOErrorEvent.IO_ERROR, onSizesLoadError);
        }
    }
}