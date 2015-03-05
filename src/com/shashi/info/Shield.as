package com.shashi.info {
import com.stamen.graphics.color.IColor;
import com.stamen.ui.BlockSprite;
import com.stamen.ui.tooltip.TooltipBlocker;

import flash.events.Event;
import flash.events.MouseEvent;
import flash.text.TextField;
import flash.utils.setTimeout;

import gs.TweenLite;

public class Shield extends BlockSprite implements TooltipBlocker {

	public function Shield(color:IColor = null) {
        super(0, 0, color);
        useHandCursor = buttonMode = true;
		addEventListener(Event.ADDED_TO_STAGE, onStage);
    }

    public function remove(event:Event = null):void {
        TweenLite.to(this, .2, {alpha: 0, onComplete: reallyRemove});
		stage.removeEventListener(Event.RESIZE, onResize);
		stage.removeEventListener(MouseEvent.CLICK, remove);
    }

    protected function reallyRemove():void {
		this.dispatchEvent(new Event('shieldRemoved'));
    }

    protected function onStage(event:Event):void {
        refresh();

        setTimeout(addListeners, 100);
    }

    protected function addListeners():void {
        stage.addEventListener(Event.RESIZE, onResize);
		stage.addEventListener(MouseEvent.CLICK, remove);
    }

    protected function onResize(event:Event):void {
        refresh();
    }

    protected function refresh(event:Event = null):void {
        if (!stage)    return;

        setSize(stage.stageWidth, stage.height);
    }
}
}