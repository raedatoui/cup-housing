package com.stamen.ui.tooltip {
import flash.display.Sprite;

import gs.TweenLite;

public function hideSprite(sprite:Sprite, ...rest):void {
    var reallyHideSprite:Function = function ():void {
        sprite.visible = false;
    }
    TweenLite.to(sprite, 0.25, {alpha: 0, onComplete: reallyHideSprite});
}
}