package com.stamen.syndication
{
    import com.adobe.utils.StringUtil;
    import com.adobe.utils.XMLUtil;
    
    public class XMLWrapper
    {
        protected var _xml:XML;
        
        public function XMLWrapper(xml:XML)
        {
            _xml = xml;
        }

        public function get xml():XML
        {
            return _xml;
        }
        
        public function set xml(value:XML):void
        {
            _xml = value;
        }
        
        public function getAttr(attrName:String, element:XML=null):String
        {
            var attr:XMLList = (element || _xml).attribute(attrName);
            return (attr.length() == 1) ? attr.toString() : null;
        }
        
        public function getText(descendent:*, element:XML=null):String
        {
            var descendents:XMLList = (element || _xml).descendants(descendent)
            return (descendents.length() > 0)
                   ? StringUtil.trim(descendents[0].text())
                   : null;
        }
        
        public static function parseHTML(html:String):XML
        {
            var replace:Array = ['&lt;', '<',
                                 '&gt;', '>',
                                 '&quot;', '"'];
            for (var i:uint = 0; i < replace.length; i += 2)
            {
                html = html.replace(replace[i], replace[i + 1]);
            }
            return new XML(html);
        }
        
        public static function parseText(xml:XML):String
        {
            if (xml.hasComplexContent())
            {
                var out:String = '';
                for each (var child:XML in xml.children())
                {
                    trace('appending text from: ' + child.toXMLString());
                    out += parseText(child) + ' ';
                }
                return out;
            }
            else
            {
                return xml.toString();
            }
        }
    }
}