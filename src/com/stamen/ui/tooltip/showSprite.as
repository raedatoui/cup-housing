package com.stamen.ui.tooltip {
import flash.display.Sprite;

import gs.TweenLite;

public function showSprite(sprite:Sprite, ...rest):void {
    sprite.visible = true;
    TweenLite.to(sprite, 0.25, {alpha: 1});
}
}
