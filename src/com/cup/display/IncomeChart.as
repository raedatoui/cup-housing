package com.cup.display {
	import com.cup.model.ColorsCUP;
	import com.cup.model.MoneyStr;
	import com.shashi.model.NumberFormat;
	import com.stamen.graphics.color.RGB;
	import com.stamen.ui.BlockSprite;
	
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	
	import gs.TweenLite;
	
	public class IncomeChart extends BlockSprite {
		public static const RENT_CHANGED:String = 'rentChanged';
		
		// display
		protected var rentLabels:RentMarkerManager;
		protected var chart:LabelPropBlockSprite;
		protected var chartLabels:PropLabelSprite;
		
		protected var dotsByValue:Dictionary = new Dictionary(true);
		
		protected var colBG:uint = 0x666666;
		

		protected var incomes:Array = [];
		
		protected var labelsByPercent:Dictionary = new Dictionary(true);
		
		public var mfi:int = 76800;
		public var maxmfi:int = 192000;
		public var minmfi:int = 192000;
		public var mfiPercents:Array = [0, .3, .5, .8, 1, 1.2, 2.5];
		public var mfiIncomes:Array = [0, 23050, 38400, 61450, 91150, 192000];
		public var mfiDescription:String = 'The bar below shows the income categories that the government uses to decide who is eligible for different affordable housing programs. ' +
			'These categories are expressed as percentages of the “median family income.” The MFI for a family of four in Greater New York (which includes the City and some of its suburbs) is $76,800 per year';
		public var mfiLabels:Array = ['', '<b>Extremely Low Income</b> \n23K or less',
			'<b>Very Low Income</b> \n23K-38K',
			'<b>Low Income</b> \n38K-61K',
			'<b>Moderate Income</b> \n61K-92K',
			'<b>Middle Income</b> \n92K-192K',
			'<b>High Income</b> \n192K or more'];
		public var mfiTips:Array = ['<b>“Extremely Low Income”</b> runs from 0% to 30% of MFI,\nor from $0 to $23,050 in income for a family of four.', 
			'<b>“Very Low Income”</b> runs from 30% to 50% of MFI,\nor from $23,050 to $38,400 in income for a family of four.', 
			'<b>“Low Income”</b> runs from 50% to 80% of MFI,\nor from $38,400 to $61,450 in income for a family of four.',
			'<b>“Moderate Income”</b> runs from 80% to 120% of MFI,\nor from $61,450 to $92,150 in income for a family of four.',
			'<b>“Middle Income”</b> runs from 120% to 250% of MFI,\nor from $92,150 to $192,000 in income for a family of four.',
			'<b>“High Income”</b> is above 250% of MFI,\nor above $192,000 in income for a family of four.'
		];

		
		public var defaultIncomes:Array = [0, 23050, 38400, 61450, 76800, 91150, 192000];
		
		protected var mfiPopColors:Array = [ColorsCUP.YELLOW, ColorsCUP.RED, ColorsCUP.BROWN, ColorsCUP.BLUE, ColorsCUP.GREEN, ColorsCUP.PINK];
		protected var mfiColors:Array = [0x000000, ColorsCUP.YELLOW, ColorsCUP.RED, ColorsCUP.BROWN, ColorsCUP.BLUE, ColorsCUP.BLUE, ColorsCUP.GREEN, ColorsCUP.PINK];

		
		protected var min:int = 0;
		protected var max:int = int(maxmfi * 1); 
		protected var grain:int = 100;
		
		
		protected var middle:MedianIncomeMarker;
		

		protected var popPercents:Array = [0, .3, .5, .8, 1.2, 2.5];
		protected var populations:Array = [];
		
	
		protected var popDisplay:Sprite;
		protected var popConnector:Sprite;
		
		protected var _rentLabel:String = '';
		protected var _rentVisible:Boolean = false;
		protected var _grouped:Boolean = false;
		
		protected var spillUp:int = 35;
		
		public function IncomeChart(w:Number = 0, h:Number = 0, mfiData:Object=null) {
			super(w, h, null);

			this.mfi = int(mfiData.mfi);
			this.maxmfi = int(mfiData.mfi);
			this.minmfi = int(mfiData.mfi);
			this.mfiDescription = mfiData.mfiDescription;
			this.mfiIncomes = mfiData.mfiIncomes;
			this.defaultIncomes = mfiData.mfiIncomes;
			this.mfiLabels = [mfiData.mfiLabel0, mfiData.mfiLabel1, mfiData.mfiLabel2, mfiData.mfiLabel3, mfiData.mfiLabel4, mfiData.mfiLabel5];
			this.mfiPercents = mfiData.mfiPercents;
			this.mfiTips = [mfiData.mfiTip0, mfiData.mfiTip1, mfiData.mfiTip2, mfiData.mfiTip3, mfiData.mfiTip4, mfiData.mfiTip5];
			
			chart = new LabelPropBlockSprite(mfiLabels, mfiTips, mfiPopColors, [0, .3, .5, .8, 1.2, 2.5, (2.5 * 1.1)], (2.5 * 1.1), w, h + spillUp);
			addChild(chart);
			
			chartLabels = new PropLabelSprite(20000, 500, mfi * 2.5 * 1.1, mfi * .025 * 2.5 * 1.1, 0, 4, w, h, RGB.white());
			chartLabels.y = h / 2;
			chartLabels.mouseEnabled = false;
			addChild(chartLabels);
			
			popDisplay = new Sprite();
			addChild(popDisplay);
			
			popConnector = new Sprite();
			addChild(popConnector);
			
			rentLabels = new RentMarkerManager(w, 48);
			rentLabels.y = h / 2;
			rentLabels.visible = false;
			addChild(rentLabels);
			
			if (!middle) {
				middle = new MedianIncomeMarker(medianFamilyIncome, 1, mfiDescription);
				middle.addEventListener(MouseEvent.CLICK, middle.onClick);
				addChild(middle);
				
				middle.x = this.width * percent(medianFamilyIncome);
				middle.y = rentVisible ? -95 : -20;
			}
			
			initPopulationCharts();
			
			grouped = false;
			rentVisible = _rentVisible;
			
			recalculateIncomesOnMFI();
		}
		
		public function set medianFamilyIncome(value:int):void {
			mfi = value;
			
			recalculateIncomesOnMFI();
		}
		
		public function get medianFamilyIncome():int {
			return mfi;
		}
		
		public function set grouped(value:Boolean):void {
			_grouped = value;
			rentVisible = rentVisible;
		}
		
		public function get grouped():Boolean {
			return _grouped;
		}
		
		public function set rentVisible(value:Boolean):void {
			_rentVisible = value;
			
			var offset:Number = rentLabels.height;
			
			rentLabels.visible = rentVisible;
			
			middle.visible = !grouped;
			TweenLite.to(middle, .2, {y: rentVisible ? -95 : -20});
			
			if (_rentVisible) {
				rentLabels.addEventListener(Event.CHANGE, onRentChange);
				
				TweenLite.to(rentLabels, .2, {y: -offset + height});
				TweenLite.to(chart, .2, {y: -offset - spillUp});
				TweenLite.to(chartLabels, .2, {y: -offset + height / 2});
				TweenLite.to(popDisplay, .2, {y: grouped ? -offset - height - spillUp : -offset - spillUp});
			}
			else {
				setPopulation(incomes, currentGranularity);
				
				rentLabels.removeEventListener(Event.CHANGE, onRentChange);
				
				var base:Number = height / 2 - spillUp;
				TweenLite.to(rentLabels, .2, {y: height / 2});
				TweenLite.to(chart, .2, {y: height / 2 - 1 - spillUp});
				TweenLite.to(chartLabels, .2, {y: height - 1});
				TweenLite.to(popDisplay, .2, {y: grouped ? base - height : base});
			}
			
			
			if (grouped) {
				if (rentVisible)
					popConnector.y = -offset - spillUp;
				else
					popConnector.y = height / 2 - 1 - spillUp;
				
				TweenLite.to(popConnector, .2, {scaleY: 1});
			}
			else {
				TweenLite.to(popConnector, .2, {scaleY: 0});
			}
		}
		
		public function get rentVisible():Boolean {
			return _rentVisible;
		}
		
		public function get rentLabel():String {
			return _rentLabel;
		}
		
		public function get rentAmount():int {
			return (rentVisible) ? rentLabels.activeRentAmount() : -1;
		}
		
		public function get currentGranularity():int {
			return grain;
		}
		
		public function setPopulation(values:Array, granularity:int = 100):void {
			grain = granularity;
			
			if (middle.selected) {
				middle.selected = false;
				middle.y = rentVisible ? -95 : -20;
			}
			
			incomes = values;
			
			if (grouped)
				drawPopulationGrouped(values, granularity);
			else
				drawPopulationDistributed(values, granularity);
			
			onRentChange();
		}
		
		protected function drawPopulationGrouped(values:Array, granularity:int = 100):void {
			popConnector.graphics.clear();
			
			var lastX:int = 0;
			var dispWidth:Number = 74;
			var drawDown:Number = height;
			var initY:Number = 0;
			
			for (var i:int = 0; i < popPercents.length; i++) {
				var amount:int = int(popPercents[i] * mfi);
				var curX:int = this.width * percent(amount);
				
				var display:PopulationDisplay = populations[i];
				display.grain = granularity;
				
				var thisWidth:Number = this.width - curX;
				
				if (i != popPercents.length - 1)
					thisWidth = this.width * percent((popPercents[i + 1] - popPercents[i]) * mfi);
				
				display.width = dispWidth;
				display.x = i * dispWidth;
				display.y = initY;
				
				display.visible = true;
				display.population = values[i] ? values[i] : 0;
				
				var g:Graphics = popConnector.graphics;
				g.beginFill(mfiPopColors[i]);
				g.moveTo(curX, 0);
				g.lineTo(i * dispWidth, -drawDown);
				g.lineTo((i + 1) * dispWidth, -drawDown);
				g.lineTo(curX + thisWidth, 0);
				g.lineTo(curX, 0);
				g.endFill();
				
				lastX = curX;
			}
		}
		
		protected function drawPopulationDistributed(values:Array, granularity:int = 100):void {
			var lastX:int = 0;
			for (var i:int = 0; i < popPercents.length; i++) {
				var percentage:Number = popPercents[i];
				var amount:int = int(percentage * mfi);
				var curX:int = this.width * percent(amount);
				
				var display:PopulationDisplay = populations[i];
				display.grain = granularity;
				
				var thisWidth:Number = this.width - curX;
				
				if (i != popPercents.length - 1)
					thisWidth = this.width * percent((popPercents[i + 1] - popPercents[i]) * mfi);
				
				display.width = 74;
				display.x = curX;// + (thisWidth - 74)/2;
				display.y = 0;
				
				display.visible = true;
				display.population = values[i] ? values[i] : 0;
				lastX = curX;
			}
		}
				
		protected function recalculateIncomesOnMFI():void {
			var curX:Number = 0;
			var stretchUp:int = popDisplay.y;
			
			for (var i:int = 0; i < mfiPercents.length; i++) {
				defaultIncomes[i] = int(mfiPercents[i] * mfi);
				
				if (defaultIncomes[i]) {
					var value:String = valueToPercentMFI(mfiPercents[i]);
					var col:uint = mfiColors[i];
					var amount:int = defaultIncomes[i];
					
					updateDotAtValue(value, amount, col, this.width * percent(amount));
					
					curX = this.width * percent(amount);
				}
			}
			
			// update the center dot
			updateDotAtValue(valueToPercentMFI(1), medianFamilyIncome, 0xFFFFFF, this.width * percent(medianFamilyIncome));
		}
		
		protected function onRentChange(event:Event = null):void {
			if (rentLabels.activePercent() > 0 && rentVisible) {
				// % of 1 of the chart
				var current:Number = rentLabels.activePercent();
				
				var count:int = 0;
				var tot:Number = 0;
				
				var min:Number = 1;
				var overCount:int = 0;
				var max:Number = 2.5 * 1.1;
				var curMFI:Number = 0;
				
				var found:Boolean = false;
				var totalPop:int = 0;
				for (var i:int = 0; i < populations.length; i++) {
					var pop:PopulationDisplay = populations[i];
					totalPop += pop.population;
					
					var per:Number = popPercents[i + 1] ? popPercents[i + 1] / max : 1;
					if (per < current) {
						tot += per;
						count += pop.population;
						
						pop.percentInactive = 1.5;
					}
					else if (!found) {
						if (true) {
							var prevPer:Number = (pop.percentMFI) / max;
							var percentDelta:Number = per - prevPer;
							var currentPercent:Number = (current - prevPer) / percentDelta;
							pop.percentInactive = currentPercent;
							overCount = pop.getPercentPop(currentPercent);
						}
						else {
							pop.percentInactive = current;
							overCount = pop.population * current;
						}
						found = true;
					}
					else {
						pop.percentInactive = 0;
					}
				}
				
				// update the rent label
				_rentLabel = '<b>' + int(100 * ((count + overCount) / totalPop)) + '%</b> ' +
					'or <b>' + NumberFormat.addCommas(count + overCount) + '</b> families cannot afford a ' +
					'' + rentLabels.currentBedrooms + ' apartment at <b>' + rentLabels.currentRent + '</b> a month.';
				
				dispatchEvent(new Event(RENT_CHANGED));
			}
		}
		
		protected function updateDotAtValue(value:String, amount:int, col:uint, cx:Number):void {
			var dot:ChartDot;
			
			if (!dotsByValue[value]) {
				dot = new ChartDot(col, value, amount);
				dotsByValue[value] = dot;
				chartLabels.addChild(dot);
			}
			else {
				dot = dotsByValue[value];
			}
			
			dot.x = cx;
		}
		
		protected function valueToPercentMFI(value:Number):String {
			return int(value * 100).toString() + '% MFI';
		}
		
		protected function labelFromPercent(value:Number):String {
			return mfiLabels[mfiPercents.indexOf(value)];
		}
		
		protected function percent(value:Number):Number {
			return value / max;
		}
		
		protected function dollars(percent:Number):int {
			return percent * max;
		}
		
		protected function initPopulationCharts():void {
			for (var i:int = 0; i < mfiIncomes.length; i++) {
				var label:String = (i < mfiIncomes.length - 1) ? MoneyStr.to$$K(mfiIncomes[i]) + ' to ' + MoneyStr.to$$K(mfiIncomes[i + 1]) : MoneyStr.to$$K(mfiIncomes[i]) + ' and up';
				var pop:PopulationDisplay = new PopulationDisplay(label, 100, 10, 10, RGB.fromHex(mfiPopColors[i]));
				pop.percentMFI = popPercents[i];
				pop.visible = false;
				// set the name to be the percentage it represents
				pop.name = valueToPercentMFI(popPercents[i]);
				popDisplay.addChild(pop);
				populations.push(pop);
			}
		}
		
		override public function setSize(w:Number, h:Number):Boolean {
			if (w != _width || h != _height) {
				_width = w;
				_height = h;
				recalculateIncomesOnMFI();
				chart.width = width;
				chartLabels.width = width;
				rentLabels.width = width;
				
				if (middle)
					middle.x = this.width * percent(medianFamilyIncome);
				
				return true;
			}
			return false;
		}
		
		public function setWidth(w:Number):void {
			_width = w;
			chartLabels.width = width;
		}
	}
}