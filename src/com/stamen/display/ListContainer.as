package com.stamen.display
{
    import com.stamen.display.Align;
    import com.stamen.display.Orient;
    import com.stamen.display.Padding;
    import com.stamen.graphics.color.IColor;
    import com.stamen.ui.BlockSprite;
    
    import flash.display.DisplayObject;
    import flash.events.Event;
    import flash.text.TextField;

    public class ListContainer extends BlockSprite
    {
        public var spacing:Number = 0;
        public var padding:Padding;

        protected var _orient:String;
        protected var _align:String;
        protected var _doLayout:Boolean = true;
        protected var preferredWidth:Number;
        protected var preferredHeight:Number;
        
        public function ListContainer(orientation:String=null, w:Number=0, h:Number=0, color:IColor=null)
        {
            if (!padding) padding = new Padding();
            
            _orient = orientation || Orient.VERTICAL;
            if (!_align) _align = Align.LEFT;
            super(w, h, color);
        }

        public function get orientation():String
        {
            return _orient;
        }
        
        public function set orientation(value:String):void
        {
            if ([Orient.HORIZONTAL, Orient.VERTICAL].indexOf(value) == -1)
            {
                throw new Error('Unrecognized value for ListContainer.orientation: "' + value + '"');
            }
            if (orientation != value)
            {
                _orient = value;
                layoutChildren();
            }
        }
        
        override public function addChild(child:DisplayObject):DisplayObject
        {
            var out:DisplayObject = super.addChild(child);
            if (child is TextField)
            {
                var field:TextField = child as TextField;
                field.multiline = field.wordWrap = true;
            }
            if (_doLayout) layoutChildren();
            return out;        
        }
        
        override public function addChildAt(child:DisplayObject, index:int):DisplayObject
        {
            var out:DisplayObject = super.addChildAt(child, index);
            if (_doLayout) layoutChildren();
            return out;
        }
        
        override public function setChildIndex(child:DisplayObject, index:int):void
        {
            if (getChildIndex(child) != index)
            {
                super.setChildIndex(child, index);
                if (_doLayout) layoutChildren();
            }
        }
        
        public function updateLayout():void
        {
            layoutChildren();
        }
        
        override public function setSize(w:Number, h:Number):Boolean
        {
            preferredWidth = w;
            preferredHeight = h;
            return super.setSize(w, h);
        }
        
        override public function set width(value:Number):void
        {
            preferredWidth = value;
            super.width = value;
        }
        
        override public function set height(value:Number):void
        {
            preferredHeight = value;
            super.height = value;
        }
        
        protected function layoutChildren():void
        {
            if (isNaN(spacing)) spacing = 0;

            var top:Number = padding.top;
            var left:Number = padding.left;
            
            var availWidth:Number = Math.max(0, width - padding.width);
            var availHeight:Number = Math.max(0, height - padding.height);
            
            if (_orient == Orient.HORIZONTAL && preferredWidth > 0)
            {
                if (_align == Align.CENTER || _align == Align.RIGHT)
                {
                    var totalWidth:Number = 0;
                    for (var c:int = 0; c < numChildren; c++)
                    {
                        var ch:DisplayObject = getChildAt(c);
                        totalWidth += ch.width;
                    }
                    if (numChildren > 1) totalWidth += spacing * (numChildren - 1);
                    
                    if (_align == Align.CENTER)
                    {
                        left += Math.floor((availWidth - totalWidth) / 2);
                    }
                    else
                    {
                        left = width - (padding.right + totalWidth);
                    }
                } 
            }
            
            var lastMargin:Number;
            for (var i:int = 0; i < numChildren; i++)
            {
                var child:DisplayObject = getChildAt(i);
                child.x = left;
                child.y = top;
                
                if (_orient == Orient.HORIZONTAL)
                {
                    if (height > 0)
                        child.height = availHeight;
                    left += child.width;
                    if (i < numChildren - 1)
                    {
                        left += spacing;
                    }
                }
                else
                {
                    if (width > 0)
                        child.width = availWidth;
                    top += child.height;
                    if (i < numChildren - 1)
                    {
                        top += spacing;
                    }
                }
                // trace(name + ' laid out "' + child.name + '" @ (' + child.x + ', ' + child.y + '), ' + child.width + ' x ' + child.height);
            }
            
            var oldWidth:Number = width;
            var oldHeight:Number = height;
            if (numChildren > 0)
            {
                if (_orient == Orient.HORIZONTAL)
                {
                    left += padding.right;
                    _width = (preferredWidth > 0)
                             ? Math.max(preferredWidth, left)
                             : left;
                }
                else
                {
                    top += padding.bottom
                    _height = (preferredHeight > 0)
                              ? Math.max(preferredHeight, top)
                              : top;
                }
            }

            if (oldWidth != width || oldHeight != height)
            {
                draw();
                dispatchEvent(new Event(Event.RESIZE));
            }
        }

        override protected function resize():void
        {
            layoutChildren();
            super.resize();
        }
    }
}