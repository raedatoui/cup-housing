package com.stamen.ui
{
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.text.TextField;

    public class TextButtonGroup extends BlockSprite
    {
        public var spacing:Number = 4;

        protected var _orientation:uint = 0;
        protected var _buttons:Array;
        protected var _selectedButton:TextButton;
        protected var _label:TextField;
        
        public function TextButtonGroup(label:TextField=null, orientation:int=-1)
        {
            _buttons = new Array();

            tabEnabled = false;
            
            if (orientation > -1)
            {
                _orientation = orientation;
            }
            _label = label;
            if (_label) addChild(_label);
            super(0, 0, null);
        }
        
        public function get buttons():Array
        {
            return _buttons.slice();
        }
        
        public function addButton(button:TextButton):void
        {
            _buttons.push(button);
            addButtonEventListeners(button);
            addChild(button);
            if (button.pressed)
            {
                selectedButton = button;
            }
            resize();
        }

        public function removeButton(button:TextButton):Boolean
        {
            var index:uint = _buttons.indexOf(button);
            if (index > -1)
            {
                _buttons.splice(index, 1);
                removeButtonEventListeners(button);
                removeChild(button);
                resize();
                return true;
            }
            else
            {
                return false;
            }
        }

        public function get length():uint
        {
            return _buttons.length;
        }
        
        public function get selectedButton():TextButton
        {
            return _selectedButton;
        }
        
        public function set selectedButton(value:TextButton):void
        {
            if (value == _selectedButton)
            {
            }
            else
            {
                if (_selectedButton)
                {
                    _selectedButton.pressed = false;
                }
                
                _selectedButton = value;
                
                dispatchEvent(new Event(Event.CHANGE, true));
            }
            if (_selectedButton)
            {
                _selectedButton.pressed = true;
            }
        }

        public function get selectedText():String
        {
            return _selectedButton ? _selectedButton.text : null;
        }
        
        public function set selectedText(value:String):void
        {
            if (selectedText != value)
            {
                var selected:Boolean = false; 
                for each (var button:TextButton in _buttons)
                {
                    if (button.text == value)
                    {
                        selectedButton = button;
                        selected = true;
                        break;
                    }
                }
                if (!selected)
                {
                    selectedButton = null;
                }
            }
        }

        public function get label():String
        {
            return _label.text;
        }

        public function set label(value:String):void
        {
            if (label != value)
            {
                if (value && contains(_label))
                {
                    removeChild(_label);
                }
                else if (value && !contains(_label))
                {
                    addChildAt(_label, 0);
                }
                _label.text = value;
                resize();
            }
        }

        protected function addButtonEventListeners(button:TextButton):void
        {
            button.addEventListener(MouseEvent.CLICK, onButtonClicked);
        }

        protected function removeButtonEventListeners(button:TextButton):void
        {
            button.removeEventListener(MouseEvent.CLICK, onButtonClicked);
        }

        protected function onButtonClicked(event:MouseEvent):void
        {
            selectedButton = event.target as TextButton;
        }

        public function getButtonByName(name:String):TextButton
        {
            return getChildByName(name) as TextButton;
        }

        override protected function resize():void
        {
            super.resize();
            updateButtonPositions();
        }
        
        override public function set width(value:Number):void
        {
            idealWidth = value;
            super.width = value;
        }
        
        override public function set height(value:Number):void
        {
            idealHeight = value;
            super.height = value;
        }
        
        protected var idealWidth:Number;
        protected var idealHeight:Number;
        
        public function updateButtonPositions():void
        {
            var x:Number = (_label && contains(_label) && _label.text != '')
                           ? Math.ceil(_label.getBounds(this).right + spacing)
                           : 0;
            var startX:Number = x;
            var y:Number = 0;
            var button:TextButton;
            for (var i:uint = 0; i < _buttons.length; i++)
            {
                button = _buttons[i] as TextButton;
                if (_orientation == 0 && idealWidth > 0 && (x + button.width) > idealWidth)
                {
                    x = startX;
                    y += Math.round(button.height + spacing);
                }
                else if (_orientation == 1 && idealHeight > 0 && (y + button.height) > idealHeight)
                {
                    x += Math.round(button.width + spacing);
                    y = 0;
                }
                button.x = x;
                button.y = y;
                if (_orientation == 1)
                {
                    y += Math.round(button.height + spacing);
                    _height = Math.max(idealHeight, button.getRect(this).bottom);
                }
                else
                {
                    x += Math.round(button.width + spacing);
                    _width = Math.max(idealWidth, button.getRect(this).right);
                }
            }
            if (!button)
            {
                _width = _height = 0;
            }
        }
    }
}