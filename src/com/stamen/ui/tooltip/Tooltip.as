package com.stamen.ui.tooltip {
import com.stamen.text.HelveticaBold;

import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.filters.DropShadowFilter;
import flash.geom.Point;
import flash.text.AntiAliasType;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.utils.clearTimeout;
import flash.utils.setTimeout;

public class Tooltip extends Sprite {
    protected var tipTimer:uint;
    protected var _active:Boolean = true;

    protected var tipField:TextField;

    protected var padding:Number = 2;
    protected var boldFontName:HelveticaBold = new HelveticaBold();

    protected var providerClass:Class;
    protected var blockerClass:Class;

    public function Tooltip() {
        mouseChildren = mouseEnabled = false;
        visible = false;
        filters = [new DropShadowFilter(1, 45, 0, 1, 3, 3, .7, 2)];

        providerClass = TooltipProvider;
        blockerClass = TooltipBlocker;

        tipField = new TextField();
        tipField.mouseEnabled = false;
        tipField.selectable = false;
        tipField.embedFonts = false;
        tipField.antiAliasType = AntiAliasType.ADVANCED;
        tipField.defaultTextFormat = new TextFormat(boldFontName.fontName, 11, 0x202020, false, null, null, null, null, null, null, null, null, null);
        addChild(tipField);

        addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
    }

    protected function onAddedToStage(event:Event):void {
        removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
        stage.addEventListener(MouseEvent.MOUSE_MOVE, checkUnderMouse);
        stage.addEventListener(MouseEvent.MOUSE_DOWN, disactivate);
        stage.addEventListener(MouseEvent.MOUSE_UP, activate);
        stage.addEventListener(Event.MOUSE_LEAVE, activate);
        addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
    }

    protected function onRemovedFromStage(event:Event):void {
        removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
        stage.removeEventListener(MouseEvent.MOUSE_MOVE, checkUnderMouse);
        stage.removeEventListener(MouseEvent.MOUSE_DOWN, disactivate);
        stage.removeEventListener(MouseEvent.MOUSE_UP, activate);
        stage.removeEventListener(Event.MOUSE_LEAVE, activate);
        addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
    }

    protected function checkUnderMouse(event:MouseEvent = null):void {
        if (!active || !stage) return;
        if (alpha == 1) {
            hideSprite(this);
            dispatchEvent(new TooltipEvent(TooltipEvent.HIDE, null));
        }
        if (tipTimer) {
            clearTimeout(tipTimer);
        }
        tipTimer = setTimeout(reallyCheckUnderMouse, 250);
    }

    protected function reallyCheckUnderMouse():void {
        if (active && stage) {

            var mousePoint:Point = new Point(stage.mouseX, stage.mouseY);

            var objs:Array = stage.getObjectsUnderPoint(mousePoint);
            objs = objs.reverse();

            var obj:DisplayObject;

            var gotOne:Boolean = false;
            for each (obj in objs) {
                if (obj is blockerClass) {
                    break;
                }
                else if (obj is providerClass) {

                    gotOne = true;
                    dispatchEvent(new TooltipEvent(TooltipEvent.SHOW, obj));

                    var tipText:String = TooltipProvider(obj).getTooltipText();

                    if (tipField.htmlText != tipText) {

                        tipField.htmlText = tipText;
                        tipField.x = padding;
                        tipField.y = 0;
                        tipField.width = tipField.textWidth + 4;
                        tipField.height = tipField.textHeight + 4;

                        redraw();
                    }

                    var p:Point;

                    if (obj is TooltipPositioner) {
                        p = TooltipPositioner(obj).getTooltipPosition();
                    }
                    else {
                        p = new Point(stage.mouseX, stage.mouseY);
                    }

                    reposition(p);

                    break;
                }
                else {
                    obj = null;
                }
            }

            if (gotOne) {
                showSprite(this);
            }
        }
    }

    protected function redraw():void {
        var w:Number = tipField.width + 2 * tipField.x;
        var h:Number = tipField.height + 2 * tipField.y;
        with (this.graphics) {
            clear();
            beginFill(0xffffff, 0.9);
            moveTo(0, 0);
            lineTo(w, 0);
            lineTo(w, h);
            lineTo(0, h);
            lineTo(0, 0);
            endFill();
        }
    }

    protected function reposition(p:Point):void {
        if (stage) {
            this.x = Math.max(1, Math.min(stage.stageWidth - this.width - 1, p.x - this.width / 2));
            this.y = Math.max(1, Math.min(stage.stageHeight - this.height - 1, p.y - this.height - 5));
        }
    }

    protected function activate(event:Event):void {
        active = true;
    }

    protected function disactivate(event:Event):void {
        active = false;
    }

    protected function set active(a:Boolean):void {
        _active = a;
        if (a) {
            checkUnderMouse();
        }
        else {
            hideSprite(this);
            dispatchEvent(new TooltipEvent(TooltipEvent.HIDE, null));
        }
    }

    protected function get active():Boolean {
        return _active;
    }

}
}