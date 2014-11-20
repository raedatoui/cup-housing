package com.stamen.utils
{
    public class ArrayUtils
    {
        /**
         * Compares two arrays, optionally supplying a comparison function.
         */
        public static function compare(a:Array, b:Array, cmp:Function=null):Boolean
        {
            if (a && b)
            {
                if (cmp == null) cmp = compareObject;
                if (a.length != b.length)
                {
                    return false;
                }
                
                for (var i:uint = 0; i < a.length; i++)
                {
                    try
                    {
                        if (!cmp(a[i], b[i]))
                        {
                            return false;
                        }
                    }
                    catch (e:Error)
                    {
                        trace('Error comparing', a[i], 'and', b[i], ':', e.message);
                        return false;
                    }
                }
                return true;
            }
            else
            {
                return !a && !b;
            }
        }

        public static function compareObject(a:Object, b:Object):Boolean
        {
            if (a is Array && b is Array)
            {
                return compare(a as Array, b as Array);
            }
            // Point, Rectangle, and ModestMaps core classes have equals() methods
            // that compare relevant properties to determine equality
            else if ((typeof a == typeof b) && a.hasOwnProperty('equals'))
            {
                return a.equals(b);
            }
            return a == b;
        }
        
        /**
         * Rotates an array by taking the first element and moving it to the end,
         * or, in reverse mode, taking the last element and putting it at the beginning.
         * The rotated element is returned.
         */
        public static function rotate(list:Array, reverse:Boolean=false):Object
        {
            var obj:Object;
            if (reverse)
            {
                obj = list.pop();
                list.unshift(obj);
            }
            else
            {
                obj = list.shift();
                list.push(obj);
            }
            return obj;
        }
    }
}