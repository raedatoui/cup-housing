package com.stamen.syndication
{
    public class MediaRSS extends XMLWrapper
    {
        public static const MEDIA_NS:Namespace = new Namespace('media', 'http://search.yahoo.com/mrss/');

        protected var content:XML;
        protected var thumbnail:XML;
        
        public function MediaRSS(xml:XML)
        {
            super(xml);
            var contentNodes:XMLList = xml.MEDIA_NS::content;
            if (contentNodes.length() > 0)
            {
                content = contentNodes[0];
            }
            var thumbNodes:XMLList = xml.MEDIA_NS::thumbnail;
            if (thumbNodes.length() > 0)
            {
                thumbnail = thumbNodes[0];
            }
        }
        
        public function get title():String
        {
            var qn:QName = new QName(MEDIA_NS, 'title');
            return getText(qn);
        }
        
        public function get description():String
        {
            var nodes:XMLList = _xml.MEDIA_NS::description;
            if (nodes.length() > 0)
            {
                var node:XML = nodes[0];
                if (node.@type == 'html')
                {
                    var html:XML = parseHTML(node.text());
                    return html.text();
                }
                else
                {
                    return node.text();
                }
            }
            return null;
        }

        public function get url():String
        {
            return getAttr('url', content);
        }

        public function get width():uint
        {
            return parseInt(getAttr('width', content));
        }
        
        public function get height():uint
        {
            return parseInt(getAttr('height', content));
        }
        
        public function get type():String
        {
            return getAttr('type', content);
        }
        
        public function get thumbnailURL():String
        {
            return getAttr('url', thumbnail);
        }
        
        public function get thumbnailWidth():uint
        {
            return parseInt(getAttr('width', thumbnail));
        }
        
        public function get thumbnailHeight():uint
        {
            return parseInt(getAttr('height', thumbnail));
        }
        
        public function get thumbnailType():String
        {
            return getAttr('type', thumbnail);
        }
    }
}