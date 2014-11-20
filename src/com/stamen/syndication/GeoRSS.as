package com.stamen.syndication
{
    public class GeoRSS
    {
        public static const GEORSS_NS:Namespace = new Namespace('georss', 'http://www.georss.org/georss');
        
        public static function getLocation(xml:XML):Array
        {
            var qn:QName = new QName(GEORSS_NS, 'point');
            var points:XMLList = xml.descendants(qn);
            if (points.length() == 1)
            {
                var text:String = points[0].text().toString();
                var parts:Array = text.split(/ +/, 2);
                if (parts.length != 2)
                {
                    throw new Error('Malformed latitude/longitude pair: expecting 2 parts, got ' + parts.length);
                }
                return [parseFloat(parts[0]), parseFloat(parts[1])];
            }
            return null;
        }
    }
}