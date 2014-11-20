package com.nyc.ui
{
	import com.modestmaps.extras.ui.Button;
	import com.modestmaps.overlays.MarkerClip;
	import com.nyc.PopupEvent;
	import com.nyc.display.HistoricalAmountGraph;
	import com.nyc.display.MTABadge;
	import com.nyc.markers.StationMarker;
	import com.nyc.model.HistoricalStationData;
	import com.nyc.style.MTA;
	import com.stamen.display.Padding;
	import com.stamen.text.HelveticaBold;
	import com.stamen.ui.tooltip.TooltipBlocker;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import gs.TweenLite;

	public class Popup extends Sprite implements TooltipBlocker
	{
		public var marker:StationMarker;
		public var data:HistoricalStationData;
		
		protected var stationName:TextField;
		protected var subwayLines:TextField;
		protected var ridership:TextField;
		protected var badgeHolder:Sprite;
		protected var graph:HistoricalAmountGraph;
		protected var close:NYCButton;
		
		protected var badges:Array = [];
		
		protected var _sticky:Boolean = false;
		protected var _subways:Array = [];
		protected var _riderAmount:String;
		protected var _index:int = -1;
		protected var _year:String;
		protected var _off:Point = new Point();
		
		protected static const boldFontName:HelveticaBold = new HelveticaBold();
		protected var format:TextFormat = new TextFormat(boldFontName.fontName, 20, 0x666666, true);
		
		public function Popup()
		{
			super();
			
			stationName = MTA.createTextField(16);
			addChild(stationName);
			
			ridership = MTA.createTextField(14);
			addChild(ridership);
			
			badgeHolder = new Sprite();
			addChild(badgeHolder);
			
			graph = new HistoricalAmountGraph();
			addChild(graph);
			
			this.filters = [MTA.dropShadow];
		}
		
		public function setMarkerData(station:StationMarker, data:HistoricalStationData, year:int=-1):void
		{
			this.marker = station;
			this.data = data;
			
			if (year != -1)	this.year = year;			
		}
		
		public function updatePopup():void
		{
			setAllText(marker.station.name, marker.station.linesServed, data.ridership[_index], (_index + 1905).toString());
			drawStationGraph(data, _index);
		}
		
		public function set sticky(value:Boolean):void
		{
			if (_sticky != value)
			{
				_sticky = value;
				
				if (_sticky)
				{
					this.useHandCursor = this.buttonMode = true;
					
					close = new NYCButton(Button.IN, 0x000000, 0xFFFFFF);
					close.rotation = 45;
					close.addEventListener(MouseEvent.CLICK, onClose);
					addChild(close);
					
					resize();
				}
				else if (close && contains(close))
				{
					close.removeEventListener(MouseEvent.CLICK, onClose);
					removeChild(close);
				}
			}
		}
		
		public function get sticky():Boolean
		{
			return _sticky;
		}
		
		public function set year(value:int):void
		{
			if (_index != value)
			{
				_index = value;
				
				if (data && marker)
				{
					updatePopup();
				}
			}
		}
		
		public function drawStationGraph(station:HistoricalStationData, index:int, color:uint=0x666666):void
		{
			resize();
			
			graph.allData = station.ridership;
			graph.drawSingleGraph(station, index, color);
		}
		
		protected function removeAllBadges():void
		{
			for each (var badge:MTABadge in badges)
			{
				if (badgeHolder.contains(badge)) 	badgeHolder.removeChild(badge);
			}
			
			badges = [];
		}
		
		public function setAllText(station:String, subways:Array, riderAmount:String, year:String):void
		{
			stationName.text = station;
			
			removeAllBadges();
			
			_subways = subways.slice();
			_riderAmount = riderAmount;
			
			var curX:int = 0;
			
			for each (var sub:String in subways)
			{
				var lineName:String = sub.split('!').join('').toUpperCase();
				if (lineName != 'JFKAIRTRAIN')
				{
					var badge:MTABadge = new MTABadge(lineName);
					badge.x = curX;
					curX += badge.width + 4;
					badgeHolder.addChild(badge);
					badges.push(badge);
				}
			}
			
			ridership.text = (riderAmount.length > 3) ? riderAmount.split('"').join('') + ' riders in ' + year : '';
			
			resize();
		}
		
		public function setPoint(offX:Number, offY:Number):void
		{
			_off.x = offX;
			_off.y = offY;
			
			resize();
		}
		
		protected function onClose(event:MouseEvent):void
		{
			sticky = false;
			TweenLite.to(this, .15, {alpha:0, y:"20", onComplete:removeMe});	
			dispatchEvent(new PopupEvent(this, PopupEvent.CLOSE, true, true));
		}
		
		protected function removeMe():void
		{
			if (this.parent && this.parent is MarkerClip)
			{
				var parentClip:MarkerClip = (this.parent as MarkerClip);
				parentClip.removeMarkerObject(this);
			}
			else if (this.parent && this.parent is DisplayObjectContainer)
			{
				this.parent.removeChild(this);
			}
		}
		
		protected function resize():void
		{
			var w:Number = Math.max(stationName.width, badgeHolder.width, ridership.width) + 16;
			var h:Number = (ridership.text.length > 0) ? 66 : 48;
			var p:Padding = new Padding(6);
			var rh:Number = h + 26 + 8 + 10;
			
			with (this.graphics)
			{
				clear();
				beginFill(0x000000);
				drawRoundRect(-w/2, -4 - rh, w, rh - 10, 24);
				
				if (sticky)
				{
					beginFill(0x000000);
					moveTo(-5, -14);
					lineTo(5, -14);
					lineTo(_off.x, _off.y);
					lineTo(-5, -14);
					endFill();					
				}
			}
			
			if (close)
			{
				close.x = w/2;
				close.y = -4 - rh - 10;
			}
			
			stationName.y = -rh;
			stationName.x = p.left - w/2;
			badgeHolder.x = p.left + 2 - w/2;
			badgeHolder.y = stationName.height + 2 - rh;
			
			ridership.y = badgeHolder.y + badgeHolder.height;
			ridership.x = p.left - w/2;
			
			graph.width = w - 20;
			graph.height = 20;
			graph.y = h - rh;
			graph.x = p.left - w/2;
		}
	}
}