package com.stamen.display {
import flash.display.Shape;
import flash.events.MouseEvent;
import flash.text.AntiAliasType;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;

public class ExampleStatefulSprite extends StatefulSprite {
    [Embed(systemFont="Helvetica Neue", fontName="HelveticaNorm", mimeType='application/x-font')]
    public var helvetica:String;

    public var background:Shape;
    public var tf:TextField;
    public var dot:Shape;
    public var stateField:TextField;

    public function ExampleStatefulSprite() {
        buildChildren();

        initStates();

        useHandCursor = buttonMode = true;
        addEventListener(MouseEvent.CLICK, function (event:MouseEvent):void {
            tweenState(getNextState());
        });

        setState('mini');
    }

    private function buildChildren():void {
        background = new Shape();
        with (background.graphics) {
            beginFill(0xffffff);
            drawRect(0, 0, 100, 100);
        }
        addChild(background);

        tf = new TextField();
        tf.embedFonts = true;
        tf.selectable = false;
        tf.mouseEnabled = false;
        tf.multiline = true;
        tf.wordWrap = true;
        tf.defaultTextFormat = new TextFormat("HelveticaNorm", 12, 0x000000, true, null, null, null, null, TextFormatAlign.LEFT, null, null, null, 0);
        tf.antiAliasType = AntiAliasType.ADVANCED; // this will be tweaked whilst animating
        tf.width = 100;
        tf.height = 100;
        tf.text = "only visible when the state is 'normal' or 'hugey'";
        addChild(tf);

        dot = new Shape();
        with (dot.graphics) {
            beginFill(0xff0000);
            drawCircle(-3.5, -3.5, 7);
        }
        addChild(dot);

        stateField = new TextField();
        stateField.embedFonts = true;
        stateField.selectable = false;
        stateField.mouseEnabled = false;
        stateField.multiline = true;
        stateField.wordWrap = true;
        stateField.defaultTextFormat = new TextFormat("HelveticaNorm", 10, 0x000000, true, null, null, null, null, TextFormatAlign.LEFT, null, null, null, 0);
        stateField.antiAliasType = AntiAliasType.ADVANCED; // this will be tweaked whilst animating
        stateField.width = 100;
        stateField.height = 15;
        stateField.text = "state";
        addChild(stateField);

    }

    private function initStates():void {
        addState('mini', {
            background: {x: -25, y: -25, width: 50, height: 50},
            tf: {x: -25, y: -25, scaleX: 0.5, scaleY: 0.5, alpha: 0},
            dot: {x: 20, y: 20, alpha: 0, scaleX: 0, scaleY: 0},
            stateField: {x: -25, y: 10}
        });
        addState('normal', {
            background: {x: -50, y: -50, width: 100, height: 100},
            tf: {x: -50, y: -50, scaleX: 1, scaleY: 1, alpha: 1},
            dot: {x: 40, y: 40, alpha: 1, scaleX: 1, scaleY: 1},
            stateField: {x: -50, y: 35}
        });
        addState('hugey', {
            background: {x: -75, y: -75, width: 150, height: 150},
            tf: {x: -75, y: -75, scaleX: 1.5, scaleY: 1.5, alpha: 1},
            dot: {x: 65, y: 65, alpha: 1, scaleX: 1, scaleY: 1},
            stateField: {x: -75, y: 60}
        });
    }

    override public function beginTween(state:String):void {
        tf.antiAliasType = AntiAliasType.NORMAL; // better for scaling text
        stateField.text = "...";
    }

    override public function endTween(state:String):void {
        tf.antiAliasType = AntiAliasType.ADVANCED; // better for reading!
        stateField.text = "state=" + state;
    }

}
}