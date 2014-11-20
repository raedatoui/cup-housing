package com.cup.ui
{
	import com.stamen.ui.tooltip.Tooltip;
	import com.stamen.ui.tooltip.TooltipBlocker;
	import com.stamen.ui.tooltip.TooltipEvent;
	import com.stamen.ui.tooltip.TooltipProvider;
	import com.stamen.ui.tooltip.hideSprite;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.geom.Point;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;

	public class CUPTooltip extends Tooltip
	{
		public function CUPTooltip()
		{
			mouseChildren = mouseEnabled = false;
			visible = false;
			filters = [ new DropShadowFilter(1,45,0,1,3,3,.7,2) ];
			
			providerClass = TooltipProvider;
			blockerClass = TooltipBlocker;
			
			tipField = new TextField();
			tipField.mouseEnabled = false;
			tipField.selectable = false;
			tipField.embedFonts = false;
			tipField.antiAliasType = AntiAliasType.ADVANCED;
			tipField.defaultTextFormat = new TextFormat(boldFontName.fontName, 13, 0xFFFFFF, false, null, null, null, null, null, null, null, null, null);
			addChild(tipField);			
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);	
		}
		
		override protected function checkUnderMouse(event:MouseEvent=null):void
		{
			if (!active || !stage) return;
			if (alpha == 1) {
				hideSprite(this);
				dispatchEvent(new TooltipEvent(TooltipEvent.HIDE, null));				
			}
			if (tipTimer) {
				clearTimeout(tipTimer);
			}
			tipTimer = setTimeout(reallyCheckUnderMouse, 100);			
		}
		
		override protected function redraw():void
		{
			var w:Number = tipField.width + 2*tipField.x;
			var h:Number = tipField.height + 2*tipField.y;
			var pad:Number = 3;
			with (this.graphics) {
				clear();
				beginFill(0x000000, 0.7);
				drawRect(-pad, -pad, w + pad*2, h + pad*2);
				endFill();
			}
		}
		
		override protected function reposition(p:Point):void
		{
			if (stage) {
				this.x = Math.max(5, Math.min(stage.stageWidth - this.width - 5, p.x - tipField.textWidth/2));
				this.y = Math.max(5, Math.min(stage.stageHeight - tipField.textHeight - 75, p.y - tipField.textHeight * 2));
			}
		}
	}
}