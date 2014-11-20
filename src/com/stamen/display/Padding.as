package com.stamen.display
{
    import flash.geom.Point;
    import flash.geom.Rectangle;
    
    public class Padding
    {
        public var top:Number = 0;
        public var right:Number = 0;
        public var bottom:Number = 0;
        public var left:Number = 0;
        
        public function Padding(...rest)
        {
            switch (rest.length)
            {
                case 1:
                    top = right = bottom = left = Number(rest[0]);
                    break;
                case 2:
                    top = bottom = Number(rest[0]);
                    left = right = Number(rest[1]);
                    break;
                case 3:
                case 4:
                    top = Number(rest[0]);
                    right = Number(rest[1]);
                    bottom = Number(rest[2]);
                    left = (rest.length == 4) ? Number(rest[3]) : right;
                    break;
            }
        }

        public function clone():Padding
        {
            return new Padding(top, right, bottom, left);
        }
        
        public function equals(other:Padding):Boolean
        {
            return other != null &&
                   other.top == top &&
                   other.right == right &&
                   other.bottom == bottom &&
                   other.left == left;
        }

        public function inflate(x:Number, y:Number):void
        {
            top += y;
            bottom += y;
            right += x;
            left += x;
        }
        
        public function inflateRect(rect:Rectangle, fromCenter:Boolean=true):void
        {
            if (fromCenter)
            {
                rect.top -= top;
                rect.right += right;
                rect.bottom += bottom;
                rect.left -= left;
            }
            else
            {
                rect.width += left + right;
                rect.height += top + bottom;
            }
        }
        

        public function deflateRect(rect:Rectangle, fromCenter:Boolean=true):void
        {
            if (fromCenter)
            {
                rect.top += top;
                rect.right -= right;
                rect.bottom -= bottom;
                rect.left += left;
            }
            else
            {
                rect.width -= left + right;
                rect.height -= top + bottom;
            }
        }
        
        public function get width():Number
        {
            return left + right;
        }
        
        public function set width(value:Number):void
        {
            left = right = value / 2;
        }
        
        public function get height():Number
        {
            return top + bottom;
        }
        
        public function set height(value:Number):void
        {
            top = bottom = value / 2;
        }
        
        public function get topLeft():Point
        {
            return new Point(left, top);
        }
        
        public function set topLeft(value:Point):void
        {
            top = value.y;
            left = value.x;
        }
        
        public function get bottomRight():Point
        {
            return new Point(right, bottom);
        }
        
        public function set bottomRight(value:Point):void
        {
            bottom = value.y;
            right = value.x;
        }
    }
}