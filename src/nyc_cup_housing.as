package {
	import com.cup.display.BoroDisplay;
	import com.cup.display.IncomeChart;
	import com.cup.display.SubBoroMap;
	import com.cup.display.WebLayout;
	import com.cup.events.AreaEvent;
	import com.cup.model.SubBoroIncomes;
	import com.cup.output.MainPrinter;
	import com.cup.output.PDFCompositor;
	import com.cup.ui.CUPHoverLabel;
	import com.cup.ui.CUPTooltip;
	import com.fonts.ConduitBold;
	import com.fonts.ConduitMedium;
	import com.modestmaps.TweenMap;
	import com.modestmaps.events.MapEvent;
	import com.modestmaps.geo.Location;
	import com.shashi.info.TextShield;
	import com.shashi.mapproviders.BaseURLMapProvider;
	import com.shashi.model.MapSyncer;
	import com.shashi.ui.DropdownButton;
	import com.shashi.ui.TextDropdown;
	import com.stamen.display.ApplicationBase;
	import com.stamen.graphics.color.RGB;
	import com.stamen.graphics.color.RGBA;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.system.Security;
	import flash.text.Font;
	import flash.utils.Dictionary;
	import flash.utils.setTimeout;
	
	import gs.TweenFilterLite;
	import gs.TweenLite;
	
	
	// import org.alivepdf.layout.Layout;
	
	[SWF(backgroundColor="#FFFFFF")]
	public class nyc_cup_housing extends ApplicationBase
	{
		
		[Embed(source='assets/imgs/ChartStrip1.png')]
		public var CHART_PNG1:Class;
		[Embed(source='assets/imgs/ChartStrip2.png')]
		public var CHART_PNG2:Class;
		
		protected var chartStrip:BitmapData;
		
		// defaults
		protected var defaultInitialSubBoro:String = '';
		protected var defaultBaseURL:String = 'http://envisioningdevelopment.net/flash/20141104/';
		protected var defaultMapURL:String = 'nyc_mercator_subboro.swf';
		protected var defaultDataURL:String = 'income_data.txt';
		
		protected var defaultQuestionMarkText:String =  'Web and Information Design: <a href="http://diametunim.com/">Sha Hwang</a>, Zach Watson, and William Wang\n' +
			'Concept and Project Direction: <a href="http://anothercupdevelopment.org/">Rosten Woo and John Mangin of the Center for Urban Pedagogy</a>\n' +
			'Additional Design: Glen Cummings of MTWTF\n' +
			'Mapping Asssistance: Inbar Kishoni\n'+
			'Data Hosting: cloudshare';
		protected var defaultIntroText:String = '';
		protected var defaultRentIntroText:String = '';
		protected var defaultWhatNowText:String = '';
		
		protected static const boroCenterManhattan:Location = new Location(40.749884, -73.926977);
		protected var boroIDs:Object = {'MANHATTAN' : 300, 'BROOKLYN' : 200, 'BRONX' : 100, 'STATEN ISLAND' : 500, 'QUEENS' : 400};
		protected var boroNames:Array = ['', 'BRONX', 'BROOKLYN', 'MANHATTAN', 'QUEENS', 'STATEN ISLAND'];
		protected var boroCenters:Array = [null, new Location(40.826883, -73.922751), 					// bronx
			new Location(40.675234, -73.971043),  						// brooklyn
			new Location(40.749884, -73.926977), 						// manhattan
			new Location(40.72956780913896, -73.86451721191406), 		// queens
			new Location(40.59101388345591, -74.13711547851562)];		// staten island
		
		// visual
		protected var shieldWidth:int = 940;
		
		// shield
		protected var shield:TextShield;
		
		// top
		protected var selector:TextDropdown;
		protected var layout:WebLayout;
		
		// map
		protected var map:TweenMap;
		protected var loader:Loader;
		protected var syncer:MapSyncer;
		protected var subBoroShapes:SubBoroMap;
		
		// hovers
		protected var hover:CUPHoverLabel;
		protected var tooltip:CUPTooltip;
		protected var display:BoroDisplay;
		
		// bottom
		protected var chart:IncomeChart;
		
		// pdf maker
		protected var pdfGenerator:MainPrinter = new MainPrinter();
		
		// data
		protected var incomeByName:Dictionary = new Dictionary(true);
		protected var incomeByArea:Dictionary = new Dictionary(true);
		protected var incomeByBorough:Dictionary = new Dictionary(true);
		protected var incomesContainedByBoro:Dictionary = new Dictionary(true);
		protected var currentArea:SubBoroIncomes;
		protected var year:int = 2006;
		
		public function nyc_cup_housing()
		{
			super(RGB.grey(0x33));
		}
		
		override public function applyParameter(name:String, value:String):Boolean
		{			
			switch (name)
			{
				case 'subboro':
					defaultInitialSubBoro = value;
					return true;
				case 'baseURL':
					defaultBaseURL = value;
					return true;
				case 'mapURL':
					defaultMapURL = value;
					return true;
				case 'dataURL':
					defaultDataURL = value;
					return true;
					
					// shields
				case 'introText':
					defaultIntroText = value;
					return true;
				case 'questionMarkText':
					defaultQuestionMarkText = value;
					return true;
				case 'rentIntroText':
					defaultRentIntroText = value;
					return true;
				case 'whatNowText':
					defaultWhatNowText = value;
					return true;
			}
			
			return false;
		}
		
		override protected function createChildren():void
		{
			super.createChildren();

			map = new TweenMap(stage.stageWidth, stage.stageHeight, true, new BaseURLMapProvider(BaseURLMapProvider.TONER, 8, 14));
			map.alpha = .75;
			map.addEventListener(MouseEvent.DOUBLE_CLICK, map.onDoubleClick);
			map.setCenterZoom(boroCenterManhattan, 12);
			TweenFilterLite.to(map.grid, 0, {type:"color", saturation:0});
			addChild(map);
			
			hover = new CUPHoverLabel(0, 0, 0, 0xFFFFFF, 0x000000, true, 12);
			hover.visible = false;
			hover.mouseEnabled = hover.mouseChildren = false;
			addChild(hover);
			
			chart = new IncomeChart(stage.stageWidth, 60);
			chart.addEventListener(IncomeChart.RENT_CHANGED, onRentUpdate);
			addChild(chart);
			
			layout = new WebLayout();
			layout.addEventListener(WebLayout.INTRO_CLICK, addIntroShield);
			layout.addEventListener(WebLayout.INFO_CLICK, addInfoShield);
			layout.addEventListener(WebLayout.ZOOM_IN_CLICK, map.zoomIn);
			layout.addEventListener(WebLayout.ZOOM_OUT_CLICK, map.zoomOut);
			layout.addEventListener(WebLayout.GROUPING_CLICK, onChartToggle);
			map.addEventListener(MapEvent.ALL_TILES_LOADED, layout.loadButtons);
			addChild(layout);
			
			display = new BoroDisplay(420, 120, RGBA.black(.9));
			display.visible = false;
			display.addEventListener(PDFCompositor.PRINT, printCurrentSelection);
			display.addEventListener(BoroDisplay.RENT_TOGGLE, onRentToggle);
			display.addEventListener(BoroDisplay.BORO_TOGGLE, onBoroToggle);
			display.addEventListener(BoroDisplay.WHATNOW_TOGGLE, onWhatNowToggle);
			display.addEventListener(BoroDisplay.CLOSE, onBoroClose);
			addChild(display);
			
			selector = new TextDropdown('Select an area from the list.');
			selector.addEventListener(Event.CHANGE, onSelectorChange);
			addChild(selector);
			
			Security.allowDomain('*');
			Security.allowDomain('http://envisioningdevelopment.net');

			loader = new Loader();
			loader.load(new URLRequest(defaultBaseURL + 'nyc.swf'), new LoaderContext(true));
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoad);
			
			addIntroShield();
			
			tooltip = new CUPTooltip();
			addChild(tooltip);
		}
		
		protected function onChartStripError(event:ErrorEvent):void
		{
			trace(event);
		}
		
		protected function onChartStripComplete(event:Event):void
		{
			var fla:Loader = (event.currentTarget as LoaderInfo).loader;
			
			Font.registerFont(ConduitBold);
			Font.registerFont(ConduitMedium);
			
			var embeddedFonts:Array = Font.enumerateFonts(false);
			for each (var f:Font in embeddedFonts)
			{
				trace("Font: ",f.fontName,f.fontStyle);
			}
			
			addIntroShield();
			
			tooltip = new CUPTooltip();
			addChild(tooltip);
		}
		
		protected function addIntroShield(event:Event=null):void
		{
			shield = new TextShield('adsadsa', defaultIntroText.toUpperCase(), shieldWidth, stage.stageHeight, RGBA.black(.8), RGBA.black(.2));
			addChild(shield);
		}
		
		protected function onLoad(event:Event):void
		{
			subBoroShapes = new SubBoroMap(loader.content as DisplayObjectContainer);
			subBoroShapes.addEventListener(AreaEvent.CLICKED, onClicked);
			subBoroShapes.addEventListener(AreaEvent.MOVED, onMouseMove);
			subBoroShapes.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			
			map.putMarker(SubBoroMap.CENTER, subBoroShapes);
			syncer = new MapSyncer(map, subBoroShapes);
			
			var urlLoader:URLLoader = new URLLoader(new URLRequest(defaultBaseURL + defaultDataURL));
			urlLoader.addEventListener(Event.COMPLETE, onDataLoad);
		}
		
		protected function onDataLoad(event:Event):void
		{
			var urlLoader:URLLoader = event.currentTarget as URLLoader;
			urlLoader.removeEventListener(Event.COMPLETE, onDataLoad);
			
			var data:Array = (urlLoader.data as String).split('\n').slice(1);
			
			urlLoader = null;
			for each (var line:String in data)
			{
				var subBoro:SubBoroIncomes = SubBoroIncomes.fromTxt(line);
				if (subBoro)
				{
					if (subBoro.id.length && subBoro.name.length)
					{
						var butt:DropdownButton = new DropdownButton(subBoro.name, '', 250, 12, 0xCCCCCC, false);
						selector.addButton(butt);
						
						incomeByArea[getID(subBoro.id)] = subBoro;
						incomeByName[subBoro.name] = subBoro;
						
						if (!incomesContainedByBoro[subBoro.borough])
							incomesContainedByBoro[subBoro.borough] = [subBoro];
						else
							incomesContainedByBoro[subBoro.borough].push(subBoro);
					}
					else if (subBoro.borough.length)
					{
						var boroButt:DropdownButton = new DropdownButton(subBoro.borough, '', 250, 12);
						selector.addButton(boroButt);
						
						incomeByBorough[subBoro.borough] = subBoro;
					}
				}
			}
			
			if (defaultInitialSubBoro.length)
			{
				var init:SubBoroIncomes = getSubBoroIncomesByID(defaultInitialSubBoro);
				if (init)
				{
					selected = init;
					subBoroShapes.selectByID(init.id);
					selector.selected = init.name;
					
					focusByBoro(init.id, .5);
				}
			}
		}
		
		protected function focusByBoro(id:String, delay:Number=0):void
		{
			var boroIndex:int = int(parseInt(id) / 100);
			if (boroCenters[boroIndex])
			{
				// center on the selected boro
				TweenLite.delayedCall(delay, map.panTo, [boroCenters[boroIndex], true]);
			}
			
			subBoroShapes.selectEntireRange(id);
		}
		
		protected function onMouseMove(event:AreaEvent):void
		{
			if (!incomeByArea[getID(event.id)]) return;
			
			
			var clickedArea:SubBoroIncomes = (incomeByArea[getID(event.id)] as SubBoroIncomes);
			
			hover.text = clickedArea.name;
			hover.visible = true;
			hover.x = mouseX;
			hover.y = mouseY - hover.height;
		}
		
		protected function onMouseOut(event:Event=null):void
		{
			hover.visible = false;
		}
		
		protected function onClicked(event:AreaEvent):void
		{
			if (!incomeByArea[getID(event.id)]) return;
			
			var clickedArea:SubBoroIncomes = (incomeByArea[getID(event.id)] as SubBoroIncomes);
			
			
			// this is roundabout, the dropdown is triggering the change event
			selector.selected = clickedArea.name;
		}
		
		protected function onChartToggle(event:Event):void
		{
			chart.grouped = !chart.grouped;
			
			if (currentArea)
				chart.setPopulation(currentArea.incomeLevels, chart.currentGranularity);
		}
		
		protected function onBoroClose(event:Event):void
		{
			subBoroShapes.selectByID('');
			display.setBoro(null);
			chart.setPopulation([]);
			chart.rentVisible = false;
		}
		
		protected function onBoroToggle(event:Event):void
		{
			if (currentArea)
			{
				var boroIndex:int = int(parseInt(currentArea.id) / 100);
				var boro:String = boroNames[boroIndex];
				selector.selected = boro;
			}
		}
		
		protected function onWhatNowToggle(event:Event):void
		{
			if (shield)	{ shield.remove(); shield = null; }
			
			shield = new TextShield('', defaultWhatNowText,
				shieldWidth, stage.stageHeight, RGBA.black(.8), RGBA.black(.2));
			
			addChild(shield);
			
		}
		
		protected function onRentToggle(event:Event):void
		{
			chart.rentVisible = !chart.rentVisible;
			
			display.rentVisible = chart.rentVisible;
			
			if (chart.rentVisible)
			{
				addRentShield();
				
				if (currentArea)
					chart.setPopulation(currentArea.incomeLevels, chart.currentGranularity);
			}
			else
			{
				// clear rent label if we're hiding rent information
				display.rentLabel = '';
			}
		}
		
		protected function onRentUpdate(event:Event):void
		{
			display.rentLabel = (chart.rentVisible) ? chart.rentLabel : '';
		}
		
		protected function onSelectorChange(event:Event):void
		{
			if (incomeByName[selector.selected])
			{
				selected = incomeByName[selector.selected];
				subBoroShapes.selectByID(currentArea.id);
				// focusByBoro(currentArea.id);
			}
			else if (incomeByBorough[selector.selected])
			{
				selected = incomeByBorough[selector.selected];
				subBoroShapes.selectByID(currentArea.id);
				
				if (boroIDs[currentArea.borough.toUpperCase()])	// to account for new york, which doesnt exist
					focusByBoro(boroIDs[currentArea.borough.toUpperCase()].toString());
			}
		}
		
		public function set selected(clickedArea:SubBoroIncomes):void
		{
			currentArea = clickedArea;
			
			chart.rentVisible = false;
			display.rentVisible = false;
			
			// find granularity
			var setGranularity:int = 100;
			if (clickedArea.borough == 'New York City')
				setGranularity = 2000;
			else if (clickedArea.borough.length || clickedArea.borough == clickedArea.name)
				setGranularity = 500;
			
			chart.setPopulation(clickedArea.incomeLevels, setGranularity);
			display.setBoro(clickedArea, chart.medianFamilyIncome, setGranularity, year);
		}
		
		protected function addInfoShield(event:Event=null):void
		{
			if (shield)	{ shield.remove(); shield = null; }
			
			shield = new TextShield('', defaultQuestionMarkText,
				shieldWidth, stage.stageHeight, RGBA.black(.8), RGBA.black(.2));
			
			addChild(shield);
		}
		
		protected var shieldSeen:Boolean = false;
		protected function addRentShield(event:Event=null):void
		{
			if (shield)	{ shield.remove(); shield = null; }
			
			if (!shieldSeen)
			{
				shield = new TextShield('', defaultRentIntroText, shieldWidth, stage.stageHeight, RGBA.black(.8), RGBA.black(.2));
				addChild(shield);
				
				shieldSeen = true;
			}
		}
		
		public function printCurrentSelection(event:Event):void
		{
			currentArea = display.getCurrentSelection();
			sendSelectionToPrint([currentArea], [currentArea.id]);
		}
		
		public function printSelection(event:Event=null, sentNames:Array=null):void
		{
			var names:Array = sentNames ? sentNames : selector.pressedButtons;
			var incomes:Array = [];
			var ids:Array = [];
			
			var boro:SubBoroIncomes;
			for each (var area:String in names)
			{
				if (incomeByName[area])
				{
					boro = incomeByName[area];
					ids.push(boro.id);
					incomes.push(boro);
				}
				else if (incomeByBorough[area])
				{
					boro = incomeByBorough[area];
				}
			}
			
			// awesomely easy to use
			if (incomes.length && ids.length)
			{
				sendSelectionToPrint(incomes, ids);
			}
		}
		
		public function sendSelectionToPrint(incomes:Array, ids:Array):void
		{
			//			if (pdfGenerator && pdfGenerator.content && currentArea)
			//			{
			//				(pdfGenerator.content as Object)['printSinglePDF'](currentArea.id, chart.rentAmount, (new CHART_PNG1() as Bitmap).bitmapData, (new CHART_PNG2() as Bitmap).bitmapData);
			//				display.onPDFStart();
			//				setTimeout(display.onPDFComplete, 5000);
			//			}
			
			if (pdfGenerator && currentArea)
			{
				pdfGenerator.printSinglePDF(currentArea.id, chart.rentAmount, (new CHART_PNG1() as Bitmap).bitmapData, (new CHART_PNG2() as Bitmap).bitmapData);
				display.onPDFStart();
				setTimeout(display.onPDFComplete, 5000);
			}
			
			// pdf.info.addEventListener(Event.COMPLETE, display.onPDFComplete);
		}
		
		protected function getID(id:String):String
		{
			return 'sub_boro_' + id;
		}
		
		protected function getCurrentName():String
		{
			return (currentArea) ? (currentArea.name.length) ? currentArea.name.toUpperCase() : currentArea.borough.toUpperCase() : '';
		}
		
		protected function getSubBoroIncomesByID(id:String):SubBoroIncomes
		{
			if (incomeByArea[getID(id)])
				return (incomeByArea[getID(id)] as SubBoroIncomes);
			else
				return null;
		}
		
		override protected function resize():void
		{
			super.resize();
			
			if (map)
			{
				map.x = 0;
				map.y = 0;
				map.setSize(stage.stageWidth, stage.stageHeight);
			}
			
			if (chart)
			{
				chart.x = 0;
				chart.y = stage.stageHeight - 60;
				chart.width = stage.stageWidth + 2;
				if (currentArea)
					chart.setPopulation(currentArea.incomeLevels);
			}
			
			if (display)
			{
				display.x = stage.stageWidth - display.width - 20;
				display.y = 20;
			}
			
			if (selector)
			{
				selector.x = 13;
				selector.y = map.y - 50;
			}
		}
	}
}
