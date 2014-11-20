package com.stamen.geom
{
    import com.stamen.utils.MathUtils;
    
    import flash.display.DisplayObject;
    import flash.geom.Matrix;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    
    public final class GeometryUtils
    {
        public static function interpolateRectangles(rect1:Rectangle, rect2:Rectangle, f:Number):Rectangle
        {
            var result:Rectangle = new Rectangle();
            var p:Point;
            result.topLeft = p = Point.interpolate(rect1.topLeft, rect2.topLeft, 1 - f);
            result.bottomRight = p = Point.interpolate(rect1.bottomRight, rect2.bottomRight, 1 - f);
            return result;
        }
        
        public static const matrixInterpolationProperties:Array = ['a', 'b', 'c', 'd', 'tx', 'ty'];
        public static function interpolateMatrices(m1:Matrix, m2:Matrix, f:Number):Matrix
        {
            if (f == 0) return m1;
            else if (f == 1) return m2;
            
            var result:Matrix = new Matrix();
            for each (var p:String in matrixInterpolationProperties)
            {
                result[p] = MathUtils.map(f, 0, 1, m1[p], m2[p]);
            }
            return result;
        }
        
        public static function fitRectToMask(rect:Rectangle, mask:Rectangle):Rectangle
        {
            var result:Rectangle = new Rectangle();
            
            var aspect:Number = rect.width / rect.height;
            if (aspect >= 1)
            {
                result.width = Math.max(mask.width, mask.height * aspect);
                result.height = result.width / aspect;
            }
            else
            {
                result.height = Math.max(mask.height, mask.width / aspect);
                result.width = result.height * aspect;
            }
            return result;
        }
        
        public static function constrainRectToBounds(rect:Rectangle, bounds:Rectangle):Rectangle
        {
            var result:Rectangle = new Rectangle();

            var aspect:Number = rect.width / rect.height;
            if (aspect >= 1)
            {
                result.width = Math.min(bounds.width, rect.width);
                result.height = result.width / aspect;
            }
            else
            {
                result.height = Math.min(bounds.height, rect.height);
                result.width = result.height * aspect;
            }
            return result;
        }
        
        public static function getConversionMatrix(a:DisplayObject, b:DisplayObject):Matrix
        {
            var cm:Matrix = a.transform.concatenatedMatrix;
            cm.invert();
            cm.concat(b.transform.concatenatedMatrix);
            return cm;
        }
    }
}