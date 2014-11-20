package com.stamen.ui
{
	import com.stamen.display.Align;
	import com.stamen.display.Padding;
	import com.stamen.graphics.ButtonStyle;
	import com.stamen.graphics.DrawStyle;
	import com.stamen.graphics.TextStyle;
	import com.stamen.graphics.color.IColor;
	import com.stamen.graphics.color.RGB;
	
	import flash.accessibility.AccessibilityProperties;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.*;

	public class TextButton extends BlockSprite
	{
	    public var focusColor:IColor;
	    
		protected var field:TextField;

        protected var _align:String = Align.CENTER;
		protected var _autoSize:Boolean = false;
		protected var _mouseOver:Boolean = false;
		protected var _mouseDown:Boolean = false;
		protected var _pressed:Boolean = false;
		protected var _toggle:Boolean = false;

        protected var _padding:Padding;
        
		protected var _baseStyle:DrawStyle = new DrawStyle(RGB.black());
		protected var _pressedStyle:DrawStyle = new DrawStyle(new RGB(255, 0, 0));
		protected var _hoverStyle:DrawStyle;
		protected var _hoverPressedStyle:DrawStyle;

		protected var _baseTextStyle:TextStyle = new TextStyle('Verdana', 10, 0xFFFFFF, true);
		
		public function TextButton(text:String, autoSize:Boolean=false, w:Number=64, h:Number=18, baseStyle:DrawStyle=null, textStyle:TextStyle=null)
		{
            if (baseStyle) _baseStyle = baseStyle.clone();
			if (textStyle) _baseTextStyle = textStyle.clone();

			_autoSize = autoSize;
			if (!_padding) _padding = new Padding(3, 5);

			field = new TextField();
			field.name = 'field';
			field.autoSize = TextFieldAutoSize.LEFT;
			_baseTextStyle.applyDefault(field);
			addChild(field);

			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			addEventListener(MouseEvent.ROLL_OUT, onRollOut);
			
			buttonMode = true;
			mouseChildren = false;

            accessibilityProperties = new AccessibilityProperties();
            accessibilityProperties.name = text;
            tabChildren = false;
            
			super(w, h, null);
            updateStyle();
            this.text = text;
		}
		
		public function get text():String
		{
			return field.text;
		}
		
		public function set text(value:String):void
		{
			if (text != value)
			{
				field.text = value;
				resize();
			}
		}
		
		public function get toggle():Boolean
		{
			return _toggle;
		}

		public function set toggle(value:Boolean):void
		{
			if (value != _toggle)
			{
				_toggle = value;
				if (pressed && !_toggle)
				{
					pressed = false;
				}
			}
		}		

		public function get pressed():Boolean
		{
			return _pressed;
		}
		
		public function set pressed(value:Boolean):void
		{
			if (value != _pressed)
			{
				_pressed = value;
				draw();
			}
		}

		protected function onMouseDown(event:MouseEvent):void
		{
			_mouseDown = true;
			if (_toggle)
			{
				draw();
			}
			else
			{
				pressed = true;
			}
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}

		protected function onMouseUp(event:MouseEvent):void
		{
			_mouseDown = false;
			if (_toggle && event.target == this)
			{
				pressed = !pressed;
			}
			else
			{
				pressed = false;
			}
			stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}

		public function get textColor():IColor
		{
			return RGB.fromHex(field.defaultTextFormat.color);
		}

		public function set textColor(value:IColor):void
		{
			var format:TextFormat = field.defaultTextFormat;
			format.color = value ? value.toHex() : _baseTextStyle.color;
			field.defaultTextFormat = format;
		}

        public function get align():String
        {
            return _align;
        }
        
        public function set align(value:String):void
        {
            if (align != value)
            {
                _align = value;
                resize();
            }
        }
        
		override protected function resize():void
		{
			var fw:Number = field.width;
			var fh:Number = field.height;
			if (_autoSize)
			{
				field.x = _padding.left - 2;
				field.y = _padding.top - 2;
				_width = Math.round(fw + _padding.width - 4);
				_height = Math.floor(fh + _padding.height - 4);
			}
			else
			{
			    switch (_align)
			    {
			        case Align.LEFT:
                        field.x = _padding.left - 2;
                        break;
                    case Align.RIGHT:
                        field.x = width - (fw + _padding.right - 2);
                        break;
			        case Align.CENTER:
			        default:
    				    field.x = (_width - fw) / 2;
			    }
				field.y = (_height - fh) / 2;
			}

			super.resize();
		}
		
		public function get padding():Padding
		{
		    return _padding;
		}
		
		public function set padding(value:Padding):void
		{
		    if (!value || !value.equals(_padding))
		    {
		        _padding = value ? value.clone() : new Padding();
		        resize();
		    }
		}
		
		public function get autoSize():Boolean
		{
			return _autoSize;
		}
		
		public function set autoSize(value:Boolean):void
		{
			if (value != _autoSize)
			{
				_autoSize = value;
				resize();
			}
		}
		
		public function get baseStyle():DrawStyle
		{
		    return _baseStyle ? _baseStyle.clone() : null;
		}
		
		public function set baseStyle(value:DrawStyle):void
		{
		    _baseStyle = value ? value.clone() : null;
            updateStyle();
		}
		
		public function get pressedStyle():DrawStyle
		{
		    return _pressedStyle ? _pressedStyle.clone() : null;
		}
		
		public function set pressedStyle(value:DrawStyle):void
		{
		    _pressedStyle = value ? value.clone() : null;
		    if (_pressed)
		    {
                updateStyle();
		    }
		}
		
		public function get hoverStyle():DrawStyle
		{
		    return _hoverStyle ? _hoverStyle.clone() : null;
		}
		
		public function set hoverStyle(value:DrawStyle):void
		{
		    _hoverStyle = value ? value.clone() : null;
		    if (_mouseOver)
		    {
                updateStyle();
		    }
		}
		
		public function get hoverPressedStyle():DrawStyle
		{
		    return _hoverPressedStyle; 
		}
		
		public function set hoverPressedStyle(value:DrawStyle):void
		{
		    _hoverPressedStyle = value ? value.clone() : null;
		    if (_mouseOver && _pressed)
		    {
                updateStyle();
		    }
		}
		
		public function get textStyle():TextStyle
		{
		    return _baseTextStyle ? _baseTextStyle : TextStyle.fromTextField(field);
		}
		
		public function set textStyle(value:TextStyle):void
		{
            if (value)
            {
                _baseTextStyle = value.clone();
                _baseTextStyle.applyDefault(field);
                resize();
            }
		}

		protected function onRollOver(event:MouseEvent):void
		{
			_mouseOver = true;
            updateStyle();
		}
		
		protected function onRollOut(event:MouseEvent):void
		{
			_mouseOver = false;
			updateStyle();
		}

        protected function updateStyle():void
        {
            /**
             * Find the right style. If we're moused over, the preference is:
             * (if pressed:) hoverPressedStyle, hoverStyle, pressedStyle, baseStyle
             * (else:) hoverStyle, baseStyle
             * Otherwise:
             * (if pressed:) pressedStyle, baseStyle
             * (else:) baseStyle
             */
            var style:DrawStyle = _mouseOver
                                  ? (_pressed ? (_hoverPressedStyle || _hoverStyle || _pressedStyle) : _hoverStyle) || _baseStyle
                                  : _pressed ? (_pressedStyle || _baseStyle) : _baseStyle;
            color = style ? style.fillColor : null;
            if (style is ButtonStyle)
            {
                textStyle = (style as ButtonStyle).textStyle;
            }
        }
	}
}