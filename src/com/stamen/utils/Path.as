package com.stamen.utils
{
    public class Path
    {
        public static var separator:String = '/';
        
        public static function join(...args):String
        {
            var parts:Array = [];
            for each (var part:String in args)
            {
                while (part.substr(-1) == separator)
                    part = part.substr(0, part.length - 1);
                else parts.push(part);
            }
            return parts.join(separator);
        }
        
        public static function split(path:String):Array
        {
            return path.split(separator);
        }
        
        public var path:String;
        public var filename:String;
        
        public function Path(path:String, filename:String)
        {
            this.path = path;
            this.filename = filename;
        }

        public function toString():String
        {
            return (path && filename)
                   ? join(path, filename)
                   : path || filename;
        }
    }
}