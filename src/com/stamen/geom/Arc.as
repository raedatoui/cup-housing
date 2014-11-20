package com.stamen.geom
{
    import flash.geom.Point;
    import flash.display.Graphics;
    import com.stamen.geom.PolarCoordinate;
    import com.stamen.geom.Line;
    import com.stamen.utils.MathUtils;

    public class Arc
    {
        public static const CLOCKWISE:int = 1;
        public static const COUNTER_CLOCKWISE:int = -1;
        
        public var circle:Circle;
        public var startTheta:Number;
        public var endTheta:Number;
        public var direction:int;
        
        public function Arc(circle:Circle=null, startTheta:Number=0, endTheta:Number=0, direction:int=CLOCKWISE)
        {
            this.startTheta = startTheta;
            this.endTheta = endTheta;
            this.circle = circle || new Circle();
            this.direction = direction;
        }
        
        public function equals(other:Arc):Boolean 
        {
            if (other)
            {
                return startTheta == other.startTheta 
                       && endTheta == other.endTheta 
                       && direction == other.direction
                       && circle.equals(other.circle);
            }
            else
            {
                return false;
            }
        }
        
        public function clone():Arc
        {
            return new Arc(circle.clone(), startTheta, endTheta, direction);
        }

        public function get centerTheta():Number
        {
            var normal:Arc = this.normalizedClone();
            return normal.startTheta + (normal.endTheta - normal.startTheta) / 2;
        }
        
        // centerTheta is read-only
        /* public function set centerTheta(theta:Number):void
        {
            var delta:Number = theta - centerTheta;
            startTheta += delta;
            endTheta += delta;
        } */

        public function draw(graphics:Graphics, detail:Number=0.2, moveToStart:Boolean=true):void
        {
            var segments:Array = getSegments(detail);
            for (var i:uint = 0; i < segments.length; i++)
            {
                var segment:Line = segments[i] as Line;
                segment.draw(graphics, moveToStart && i == 0);
            }
        }

        public function reverse():void
        {
            var tmp:Number = endTheta;
            endTheta = startTheta;
            startTheta = tmp;
            direction = -direction;
        }
        
        /**
         * Return a copy of this Arc, with the same effective bounds and direction, 
         * but with guaranteed startTheta < endTheta. Useful for determining the
         * interior angle of the arc.
         */
        public function normalizedClone():Arc
        {
            var start:Number = MathUtils.normalizeRadians(startTheta);
            var end:Number = MathUtils.normalizeRadians(endTheta);
            
            if (start < end && direction == COUNTER_CLOCKWISE) {
                start += Math.PI*2;
                
            } else if(start > end && direction == CLOCKWISE) {
                end += Math.PI*2;
            }

            var arc:Arc = new Arc(circle.clone(), start, end, direction);
            if (direction == COUNTER_CLOCKWISE)
            {
                arc.reverse();
            }
            
            // guaranteed: start < end
            return arc;
        }
        
        private var lastSegments:Array;
        private var lastNormalArc:Arc;
        
        /**
         * Retrieve an array of lines useful for drawing this arc.
         * @param   detail refers to number of line segments per radial degree.
         */
        public function getSegments(detail:Number=.03):Array
        {   
            var normalArc:Arc = this.normalizedClone();
            
            // the assumption here is that cloning arrays of lines
            // is cheaper than recalculating all the trig
            if (lastNormalArc && normalArc.equals(lastNormalArc) && lastSegments)
            {
                var cloneSegments:Array = [];
                for each (var segment:Line in lastSegments)
                {
                    cloneSegments.push(segment.clone());
                }
                return cloneSegments;
            }
            else
            {
                lastNormalArc = undefined;
                lastSegments = undefined;
            }
            
            var delta:Number = normalArc.endTheta - normalArc.startTheta;
            
            if (delta == 0)
            {
                return [];
            }
            else if (delta % (Math.PI * 2) == 0)
            {
                trace('impossible delta');
                return [];
            }
            
            var step:Number = (Math.PI/180) / detail;
            
            var reverse:Boolean = (direction == COUNTER_CLOCKWISE);
            
            var segments:Array = new Array();
            var p1:PolarCoordinate = new PolarCoordinate(normalArc.startTheta, normalArc.circle.radius);
            var p2:PolarCoordinate = new PolarCoordinate(Math.min(normalArc.endTheta, normalArc.startTheta + step),
                                                         normalArc.circle.radius);
            var pc1:Point = p1.toCartesian(normalArc.circle.center);
            var pc2:Point = p2.toCartesian(normalArc.circle.center);
            while (p1.theta < normalArc.endTheta)
            {
                var line:Line = new Line(reverse ? pc2 : pc1,
                                         reverse ? pc1 : pc2);
                if (reverse)
                {
                    segments.unshift(line);
                }
                else
                {
                    segments.push(line);
                }
                p1.theta += step;
                p2.theta += step;
                if (p2.theta > normalArc.endTheta) {
                    p2.theta = normalArc.endTheta;
                }
                pc1 = pc2.clone();
                pc2 = p2.toCartesian(normalArc.circle.center);
            } 
            
            lastNormalArc = normalArc;
            // need to copy segments (so we can reuse them next call)
            // because callers of getSegments might mess with them
            lastSegments = [];
            for each (var line:Line in segments) {
                lastSegments.push(line.clone());
            }
            
            return segments;
        }

        /**
         * Get a circle which passes through startTheta
         * and endTheta, tangent to this.circle.
         */
        public function getTangentCircle(debug:Graphics=null):Circle
        {
            var delta:Number = endTheta - startTheta;
            
            if(delta == 0) {
                trace('Arc.getTangentCircle(): 0 radius circle!');
                return null;

            } else if(delta == Math.PI) {
                trace('Arc.getTangentCircle(): Infinitely large circle!');
                return null;
            }

            // angle to the circle center
            var theta:Number = (startTheta + endTheta) / 2;
            
            // distance to the circle center
            var distance:Number = circle.radius / Math.cos(delta / 2);
            
            // radius of the circle
            var radius:Number = circle.radius * Math.tan(delta / 2);
            
            // center of the circle
            var center:Point = (new PolarCoordinate(theta, distance)).toCartesian(circle.center);

            return new Circle(radius, center);
        }
        
        /**
         * Get an arc which lies on the tangent circle, starting and ending
         * at the boundaries of this arc.
         * @param   inside True for inside this circle, false for outside.
         */
        public function getTangentArc(inside:Boolean=false, debug:Graphics=null):Arc
        {
            var connCircle:Circle = getTangentCircle();

            if (!connCircle)
            {
                trace('Arc.getTangentArc(): no connecting circle!');
                return null;
            }
            
            var connArc:Arc = (new Arc(connCircle,
                                       startTheta - Math.PI / 2,
                                       endTheta + Math.PI / 2,
                                       direction)).normalizedClone();
            
            if ((inside && (connArc.endTheta - connArc.startTheta) > Math.PI)
                || (!inside && (connArc.endTheta - connArc.startTheta) < Math.PI))
            {
                connArc.direction = -connArc.direction;
            }
            
            return connArc;
        }
    }
}
