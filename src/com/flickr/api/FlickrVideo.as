package com.flickr.api
{
    import com.stamen.media.MediaType;
    
    public class FlickrVideo extends FlickrPhoto
    {
        public static var SWFURL:String = 'http://flickr.com/apps/video/stewart.swf';
        public static var defaultVersion:String = '59809';
        public static var defaultLang:String = 'en-us';
        
        public function FlickrVideo(id:String)
        {
            super(id);
            _media = MediaType.VIDEO;
        }
        
        public static function fromXML(xml:XML):FlickrVideo
        {
            var video:FlickrVideo = new FlickrVideo(xml.@id);
            video.applyXML(xml);
            return video;
        }

        override public function get label():String
        {
            return 'Video by ' + authorName + ' on Flickr';
        }
        
        public function get authorID():String
        {
        	return _ownerID;
        }
    }
}