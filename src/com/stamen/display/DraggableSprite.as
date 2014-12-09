package com.stamen.display {
import flash.display.Sprite;
import flash.events.*;
import flash.geom.Point;
import flash.geom.Rectangle;

public class DraggableSprite extends Sprite {
    public var dragRect:Rectangle;

    protected var _draggable:Boolean;
    protected var _dragging:Boolean = false;

    public function DraggableSprite(draggable:Boolean = true) {
        super();
        this.draggable = draggable;
    }

    public function set draggable(isDraggable:Boolean):void {
        if (isDraggable != _draggable) {
            var wasDraggable:Boolean = _draggable;
            _draggable = isDraggable;

            if (_draggable) {
                addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
            }
            else {
                removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);

                if (_dragging) {
                    onMouseUp(null);
                }
            }

            buttonMode = useHandCursor = _draggable;
        }
    }

    public function get draggable():Boolean {
        return _draggable;
    }

    public function get dragging():Boolean {
        return _dragging;
    }

    override public function startDrag(lockCenter:Boolean = false, bounds:Rectangle = null):void {
        if (!_dragging) {
            super.startDrag(lockCenter, bounds || dragRect);
            _dragging = true;
            stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
            stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
            stage.addEventListener(Event.MOUSE_LEAVE, onMouseLeaveStage);
        }
    }

    override public function stopDrag():void {
        if (_dragging) {
            super.stopDrag();
            _dragging = false;
            stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
            stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
            stage.removeEventListener(Event.MOUSE_LEAVE, onMouseLeaveStage);
        }
    }

    protected function onMouseDown(event:MouseEvent):void {
        startDrag();
        parent.setChildIndex(this, parent.numChildren - 1);
    }

    protected var lastPos:Point;

    protected function onMouseMove(event:MouseEvent):void {
        lastPos = new Point(x, y);
        dispatchEvent(new Event(Event.CHANGE, false));
    }

    protected function onMouseUp(event:MouseEvent):void {
        stopDrag();
        if (lastPos != new Point(x, y)) {
            dispatchEvent(new Event(Event.CHANGE, false));
        }
        lastPos = null;
    }

    protected function onMouseLeaveStage(event:Event):void {
        stopDrag();
    }
}
}