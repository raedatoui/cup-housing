package com.stamen.syndication
{
    public class RSSEnclosure extends XMLWrapper
    {
        public function RSSEnclosure(xml:XML)
        {
            super(xml);
        }
        
        public function get url():String
        {
            return getAttr('url');
        }
        
        public function get length():uint 
        {
            return parseInt(getAttr('length'));
        }
        
        public function get type():String
        {
            return getAttr('type');
        }
    }
}