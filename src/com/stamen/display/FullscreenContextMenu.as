package com.stamen.display {
import flash.display.InteractiveObject;
import flash.display.StageDisplayState;
import flash.events.ContextMenuEvent;
import flash.ui.ContextMenu;
import flash.ui.ContextMenuItem;

// can't extend ContentMenu, so use FullscreenContextMenu.init(this) in your app Sprite instead
public class FullscreenContextMenu {
    public function FullscreenContextMenu(enforcer:SingletonEnforcer) {

    }

    public static function init(obj:InteractiveObject):void {
        // create the context menu, remove the built-in items,
        // and add our custom items
        var fullscreenCM:ContextMenu = new ContextMenu();
        fullscreenCM.addEventListener(ContextMenuEvent.MENU_SELECT, menuHandler);
        fullscreenCM.hideBuiltInItems();

        var fs:ContextMenuItem = new ContextMenuItem("Go Full Screen");
        fs.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, goFullScreen);
        fullscreenCM.customItems.push(fs);

        var xfs:ContextMenuItem = new ContextMenuItem("Exit Full Screen");
        xfs.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, exitFullScreen);
        fullscreenCM.customItems.push(xfs);

        // finally, attach the context menu to a movieclip
        obj.contextMenu = fullscreenCM;

    }

    // functions to enter and leave full screen mode
    private static function goFullScreen(event:ContextMenuEvent):void {
        event.contextMenuOwner.stage.displayState = StageDisplayState.FULL_SCREEN;
    }

    private static function exitFullScreen(event:ContextMenuEvent):void {
        event.contextMenuOwner.stage.displayState = StageDisplayState.NORMAL;
    }

    // function to enable and disable the context menu items,
    // based on what mode we are in.
    private static function menuHandler(event:ContextMenuEvent):void {
        if (event.contextMenuOwner.stage.displayState == StageDisplayState.NORMAL) {
            event.target.customItems[0].enabled = true;
            event.target.customItems[1].enabled = false;
        }
        else {
            event.target.customItems[0].enabled = false;
            event.target.customItems[1].enabled = true;
        }
    }

}
}

internal class SingletonEnforcer {
}