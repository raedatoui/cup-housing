package com.stamen.utils
{
	public class DateUtils extends DateBase
	{
		public static function fromTimestamp(timestamp:*):Date
		{
			return new Date(Number(timestamp) * 1000);
		}

		public static function toTimestamp(date:Date):uint
		{
			return (date.time / 1000) >> 0;
		}
		
		public static function copy(date:Date):Date
		{
			return fromTimestamp(toTimestamp(date));
		}
		
		public static function parseRFC822(str:String):Date
		{
		    trace('parsing: ' + str);
		    var day:Array = str.match(/^([A-Z][a-z]{2}), /);
		    if (day)
		    {
		        trace('got day: ' + day[1]);
		        str = str.substr(5);
		        trace('remainder: ' + str);
		    }
		    var parts:Array = str.split(/ +/);
		    if (parts.length != 5)
		    {
		        throw new Error('Bad date format: should have 5 parts, got ' + parts.length); 
		    }
		    
		    // 09 Apr 2008 16:53:01 PDT
            var date:uint = parseInt(parts[0]);
            var month:int = monthNamesShort.indexOf(parts[1]);
            if (month == -1)
            {
                throw new Error('Invalid month: "' + parts[1] + '"');
            }
            var year:uint = parseInt(parts[2]);
            var time:Array = (parts[3] as String).split(':');
            if (time.length != 3)
            {
                throw new Error('Invalid time format: "' + parts[3] + '"');
            }
            var hour:uint = parseInt(time[0]);
            var minute:uint = parseInt(time[1]);
            var second:uint = parseInt(time[2]);

            // Dunno what to do with this...
            var tz:String = parts[4];

            var timestamp:Number = Date.UTC(year, month, date, hour, minute, second);
            return new Date(timestamp);
		}
		
		public static function parseDateTime(str:String):Date
		{
		    var date:Date = new Date();
		    if (str.indexOf(' ') > -1)
		    {
    		    date.fullYear = parseInt(str.substr(0, 4));
    		    date.month = parseInt(str.substr(5, 2)) - 1;
    		    date.date = parseInt(str.substr(8, 2));
    		    if (str.length > 10)
    		    {
        		    date.hours = parseInt(str.substr(11, 2));
        		    date.minutes = parseInt(str.substr(14, 2));
        		    date.seconds = parseInt(str.substr(17, 2));
        		}
        		return date;
            }
            /*
            else
            {
                var parts:Array = chunkString(str, 4, 2, 2);
                date.fullYear = parseInt(parts.shift());
                date.month = parseInt(parts.shift()) - 1;
                date.date = parseInt(parts.shift());
            }
            */
            
		    return null;
		}
		
		public static function chunkString(str:String, ...rest):Array
		{
		    var parts:Array = [];
		    var offset:int = 0;
		    for each (var len:int in rest)
		    {
		        parts.push(str.substr(offset, len));
		        offset += len;
		    }
		    return parts;
		}
	}
}