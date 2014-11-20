package com.stamen.graphics.color
{
    public class ColorPalette
    {
        public static const DEFAULT_LOW:HSV = new HSV(240, 1, 1);
        public static const DEFAULT_HIGH:HSV = new HSV(0, 1, 1);
        
        public var low:IColor;
        public var high:IColor;
        public var bad:IColor = RGB.black();
        public var interpolateAsRGB:Boolean = true;
        
        public static function fromRGB(low:uint, high:uint, alpha:Number=0):ColorPalette
        {
            var palette:ColorPalette = new ColorPalette(RGBA.fromHex(low), RGB.fromHex(high));
            if (alpha > 0)
            {
                palette.low = RGBA.fromRGB(palette.low as RGB, alpha);
                palette.high = RGBA.fromRGB(palette.high as RGB, alpha);
            }
            return palette;
        }
        
        public static function fromRGBA(low:uint, high:uint):ColorPalette
        {
            return new ColorPalette(RGBA.fromHex(low), RGBA.fromHex(high));
        }
        
        public function ColorPalette(low:IColor=null, high:IColor=null)
        {
            this.low = low || DEFAULT_LOW;
            this.high = high || DEFAULT_HIGH;
        }

        public function getColor(f:Number):IColor
        {
            var invalid:IColor = bad ? bad.clone() : null;
            if (f < 0 || f > 1)
            {
                throw new ArgumentError('f must be a number between 0 and 1');
            }
            else if (f == 0)
            {
                return low ? low.clone() : invalid;
            }
            else if (f == 1)
            {
                return high ? high.clone() : invalid;
            }
            return (low && high)
                   ? low.blend(high, f, interpolateAsRGB)
                   : invalid;
        }
        
        public function reverse():void
        {
            var tmp:IColor = low ? low.clone() : null;
            low = high ? high.clone() : null;
            high = tmp;
        }
        
        public function set alpha(value:Number):void
        {
            low = low ? RGBA.fromRGB(low.toRGB(), value) : DEFAULT_LOW.toRGBA(value);
            high = high ? RGBA.fromRGB(high.toRGB(), value) : DEFAULT_HIGH.toRGBA(value);
        }

        public function equals(other:ColorPalette):Boolean
        {
            return high
                   && Color.compare(low, other.low)
                   && Color.compare(high, other.high)
                   && Color.compare(bad, other.bad)
                   && interpolateAsRGB == other.interpolateAsRGB;
        }
        
        public function clone():ColorPalette
        {
            var copy:ColorPalette = new ColorPalette();
            if (low) copy.low = low.clone();
            if (low) copy.high = high.clone();
            if (bad) copy.bad = bad.clone();
            copy.interpolateAsRGB = interpolateAsRGB;
            return copy;
        }
    }
}