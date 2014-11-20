package com.stamen.syndication
{
    import com.adobe.utils.DateUtil;
    import com.adobe.utils.StringUtil;
    
    public class RSSItem extends XMLWrapper
    {
        public function RSSItem(xml:XML)
        {
            super(xml);
        }

        public function get title():String
        {
            return getText('title');
        }
        
        public function get link():String
        {
            return getText('link');
        }
        
        public function get description():String
        {
            var desc:String = getText('description');
            if (StringUtil.beginsWith(desc, '<p>'))
            {
                var html:XML = parseHTML('<div>' + desc + '</div>');
                var out:String = parseText(html);
                return out;
            }
            return desc;
        }
        
        public function get author():String
        {
            return getText('author');
        }
        
        public function get pubDate():Date
        {
            return DateUtil.parseRFC822(getText('pubDate'));
        }
        
        public function get guid():String
        {
            return getText('guid');
        }
        
        public function get enclosure():RSSEnclosure
        {
            var nodes:XMLList = _xml.enclosure;
            if (nodes.length() == 1)
            {
                return new RSSEnclosure(nodes[0]);
            }
            return null;
        }
        
        public function get enclosures():Array
        {
            var nodes:XMLList = _xml.enclosure;
            if (nodes.length() > 0)
            {
                var enclosures:Array = new Array();
                for each (var node:XML in nodes)
                {
                    enclosures.push(new RSSEnclosure(node));
                }
                return enclosures;
            }
            return [];
        }
        
        public function get location():Array
        {
            return GeoRSS.getLocation(_xml);
        }
    }
}