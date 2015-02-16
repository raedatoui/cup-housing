﻿package com.cup.output {	import com.cup.model.SubBoroIncomes;	import com.fonts.ConduitBold;	import com.fonts.ConduitMedium;		import flash.display.Bitmap;	import flash.display.BitmapData;	import flash.display.Loader;	import flash.display.Sprite;	import flash.events.Event;	import flash.events.EventDispatcher;	import flash.geom.Matrix;	import flash.geom.Point;	import flash.geom.Rectangle;	import flash.net.URLLoader;	import flash.net.URLRequest;	import flash.text.Font;	import flash.text.TextField;	import flash.text.TextFormat;	import flash.text.TextFormatAlign;	import flash.utils.ByteArray;	import flash.utils.Dictionary;		import org.alivepdf.colors.RGBColor;	import org.alivepdf.display.Display;	import org.alivepdf.encoding.PNGEncoder;	import org.alivepdf.layout.Orientation;	import org.alivepdf.layout.Size;	import org.alivepdf.layout.Unit;	import org.alivepdf.pdf.PDF;	import org.alivepdf.saving.Download;	import org.alivepdf.saving.Method;			public class PDFCompositor extends Sprite {		public static const PRINT:String = 'print';				//*** Map position on PDF		protected var defaultFontName:String = 'Courier';		protected var defaultBoldName:String = 'Arial';		protected var defaultVariableColor:uint = 0x000000;						public var margin:int = 36;		public var stripHeight:int = 50;		public var titleHeight:int = 15;		public var chartMargin:int = 5;				// inset from left		public var barMargin:int = 3;		public var textDim:Point = new Point(365, 223);		public var textOffset:Point = new Point(4, -4);		public var textMargin:int = 12;		public var textBoxDim:Point = new Point(368, 176);		public var mapFitDimensions:Point = new Point(256, 256);		public var mapFitLocation:Point = new Point(433, 168);		public var pageDimensions:Point = new Point(792, 612);				public var estimatedRent:int = 1200;				public var squareWidth:int = 8;		public var squareMargin:Number = 1;		public var squareValue:Number = 0;				public var scale:Number = 1;		public var offset:Point = new Point;		public var stripAdded:Boolean = false;		public var info:EventDispatcher;		public var outputPDF:PDF;		public var incomeDataArray:Array = new Array;				protected var workingBorough:String;		protected var svgLoader:URLLoader;		protected var pngLoader:Loader;		protected var outlineDict:Dictionary = new Dictionary();		protected var boroughList:Array = new Array();		protected var outlineList:Array = new Array();		protected var islandArray:Array = new Array();		protected var selectedBoroughs:Array = new Array;				protected var gLeft:Number;		protected var gRight:Number;		protected var gTop:Number;		protected var gBottom:Number;				protected var familyCOunt:int = 0;		protected var multiPage:Boolean;		protected var printURL:String;		protected var shapeURL:String;				protected var chartColors:Array = [0xF49B18, 0xED1C24, 0x5E0F0C, 0x2B338C, 0x0C8040, 0xD54799];		protected var incomeDescriptions:Array = ["Extremely Low Income", "Very Low Income", "Low Income", "Moderate Income", "Middle Income", "High Income"];		protected var incomeRanges:Array = ["($23K OR LESS)", "($24K TO $38K)", "($38K TO $61K)", "($61K TO $91K)", "($91K TO $192K)", "($192K OR MORE)"];		protected var barLocationsAsPercents:Array = [0, 0.11, 0.183, 0.293, 0.434, 0.914]; //??????		protected var boroughPrefixes:Array = ['', 'bronx', 'brooklyn', 'manhattan', 'queens', 'statenisland'];		protected var incomeBreakPoints:Array = [0.000, 25.750,42.950,85.900,103.080,200.000,220.000];		protected var year:int;				protected var tgReg:Font = new ConduitMedium();		protected var tgBold:Font = new ConduitBold();		protected var mainMFI:int;				public function PDFCompositor(printURL:String, shapeURL:String, famSquareVal:int, colors:Array, descriptions:Array, ranges:Array, breakPoints:Array, year:int, mfi:Number):void {			this.printURL = printURL;			this.shapeURL = shapeURL;			this.chartColors = colors;			this.incomeDescriptions = descriptions;			this.incomeRanges = ranges;			this.incomeBreakPoints = breakPoints;			this.year = year;			this.mainMFI = mfi;						squareValue = famSquareVal;						defaultFontName = tgReg.fontName;			defaultBoldName = tgBold.fontName;						info = new EventDispatcher();		}				public function print(incomes:Array, boroughs:Array, rent:int, multipage:Boolean = true):void {			estimatedRent = rent;			multiPage = multipage;			selectedBoroughs = boroughs;			incomeDataArray = incomes;						var svgString:URLRequest = new URLRequest(shapeURL);			svgLoader = new URLLoader(svgString);						svgLoader.addEventListener(Event.COMPLETE, readBoroughs);		}						protected function createPDF():void {			outputPDF = new PDF(Orientation.LANDSCAPE, Unit.POINT, Size.LETTER);			outputPDF.setDisplayMode(Display.REAL);//zoom 100%			outputPDF.setAutoPageBreak(false, 0);									if (multiPage) {				trace(incomeDataArray, incomeDataArray.length);				for each(var iData:Object in incomeDataArray) {					//newPage(incomeDataArray);					trace(iData is SubBoroIncomes, iData);					newPage([iData as SubBoroIncomes]);				}							}			else {				newPage(incomeDataArray);			}						savePDF();		}				protected function newPage(incomes:Array, highlightColor:uint = 0x444444, generalColor:uint = 0xaaaaaa, backColor:uint = 0xdddddd, lineWeight:Number = 0, lineColor:uint = 0xcccccc):void {			outputPDF.addPage();// we add a page			outputPDF.lineStyle(new RGBColor(0x000000));// set the line style color			//apparently necessary, but no idea why			outputPDF.drawCircle(-10, -10, 0);										this.calculateDimensions();			this.drawBackground(lineWeight, backColor);			this.drawBoroughs(lineWeight, generalColor, highlightColor);						/***********************			 Add Chart			 ***********************/			var families:int = this.drawChart(incomes);						this.drawMask();			this.drawText(incomes, families);				}				protected function calculateDimensions():void {			/***********************			 Calculate scale and boroughs to draw			 ***********************/						var mapUL:Point = new Point(160, 160);			var mapDimensions:Point = new Point(92, 92);									//Get global max/mins			gLeft = 1000;			gRight = -1000;			gTop = 1000;			gBottom = -1000;						for each(var inc:String in selectedBoroughs) {				var boroughData:BoroughData = outlineDict[inc];				gLeft = Math.min(gLeft, boroughData.left);				gRight = Math.max(gRight, boroughData.right);				gTop = Math.min(gTop, boroughData.top);				gBottom = Math.max(gBottom, boroughData.bottom);			}									trace("globals:", gRight, gLeft, gTop, gBottom);			var selectedWidth:Number = gRight - gLeft;			var selectedHeight:Number = gBottom - gTop;						var vScale:Number = (mapFitDimensions.y) / selectedHeight;			var hScale:Number = (mapFitDimensions.x) / selectedWidth;						scale = Math.min(vScale, hScale);			var scaleMultiplier:Number = ((scale - 3.72) / -3.088) / 2.5 + 1;			scaleMultiplier *= (squareValue != 100) ? 1.25 : 1;			scale *= scaleMultiplier;						offset.x = mapFitLocation.x - gLeft * scale + ((mapFitDimensions.x) - selectedWidth * scale) / 2;			offset.y = mapFitLocation.y - gTop * scale + ((mapFitDimensions.y) - selectedHeight * scale) / 2;						gLeft = (mapFitLocation.x - offset.x) / scale;			gRight = (mapFitLocation.x + mapFitDimensions.x - offset.x) / scale;			gTop = (mapFitLocation.y - offset.y) / scale;			gBottom = (mapFitLocation.y + mapFitDimensions.y - offset.y) / scale;									trace("boroughs", selectedBoroughs, "offset:", offset, "scale:", scale);		}				protected function drawBackground(lineWeight:Number, backColor:uint):void {			/***********************			 DRAW THE BACKGROUND			 ***********************/						//Ocean			outputPDF.beginFill(new RGBColor(0xeeeeee));			outputPDF.drawRect(new Rectangle(0, 0, pageDimensions.x, pageDimensions.y));			outputPDF.endFill();									var tempBorough:BoroughData = outlineDict["und"];			for each (var pointArray:Array in tempBorough.pointArrays) {				drawPolyOutline(pointArray, tempBorough.translate, backColor, lineWeight, 0xffffff);			}		}						protected function drawBoroughs(lineWeight:Number, generalColor:uint, highlightColor:uint):void {			/***********************			 DRAW THE BOROUGHS			 ***********************/			lineWeight = 1.5;						for each (var id:String in outlineList) {				var boroughColor:uint = generalColor;				var boroughLineColor:uint = 0xeeeeee;								for each (var borough:int in selectedBoroughs) {					if (borough.toString() == id) {						boroughColor = highlightColor;					}				}								var tempBorough:BoroughData = outlineDict[id];								for each (var pointArray:Array in tempBorough.pointArrays) {					drawPolyOutline(pointArray, tempBorough.translate, boroughColor, lineWeight, boroughLineColor);				}			}		}			protected function drawChart(incomes:Array):int {						var reg6Format:TextFormat = new TextFormat(defaultFontName, 24, 0xffffff, false, null, null, null, null, TextFormatAlign.CENTER);			var bold7Format:TextFormat = new TextFormat(defaultBoldName, 32, 0xffffff, false, null, null, null, null, TextFormatAlign.LEFT);			var bold8Format:TextFormat = new TextFormat(defaultBoldName, 32, 0xffffff, false, null, null, null, null, TextFormatAlign.CENTER);						var textBlock:TextField = new TextField;			textBlock.embedFonts = true;						textBlock.width = 88;			textBlock.height = 32;						var tempData:BitmapData;			var byteData:ByteArray;			var textBoxOffset:Point;									/***********************			 DRAW THE MFI BAR			 ***********************/				var stripTop:int = pageDimensions.y - stripHeight - margin;			var stripWidth:int = (pageDimensions.x - margin * 2);			var squareColor:uint = 0xffffff;			var familyCount:int = 0;						for (var i:int = 0; i < 6; i++) {				var leftX:Number = margin + barMargin + barLocationsAsPercents[i] * stripWidth;				var rightX:Number = margin + chartMargin + 3.16 * incomeBreakPoints[i + 1];				var families:int = 0;								var familySquares:int = 0;				families = incomes[0].incomeLevels[i];				familyCount += families;				familySquares = Math.ceil(families / squareValue);								var squaresWide:int = 5;//(rightX - leftX)/squareWidth;				var squaresHigh:int = Math.ceil(familySquares / squaresWide);				var barHeight:Number = squaresHigh * squareWidth;				var barWidth:Number = rightX - leftX;				var squareOffset:int = (barWidth - squaresWide * squareWidth) / 2;				outputPDF.lineStyle(new RGBColor(chartColors[i]),0);				outputPDF.beginFill(new RGBColor(chartColors[i]));				outputPDF.drawRect(new Rectangle(leftX+squareMargin, stripTop-squareMargin, rightX, stripWidth));				outputPDF.endFill();								textBlock.text = this.incomeDescriptions[i] +"\n\n" + this.incomeRanges[i];				textBlock.setTextFormat(bold7Format);				textBlock.textColor = 0xFFFFFF;				textBlock.width = 250;				textBlock.height = stripWidth;				tempData = new BitmapData(textBlock.width, textBlock.height, false, chartColors[i]);				textBoxOffset = new Point(leftX + squareMargin*2, stripTop + squareMargin*2);				tempData.draw(textBlock, new Matrix(1, 0, 0, 1, 0, 1));								byteData = new ByteArray;				byteData = PNGEncoder.encode(tempData, 1);				byteData.position = 0;								outputPDF.addImageStream(byteData, textBoxOffset.x, textBoxOffset.y, tempData.width /4, tempData.height/4);								/***********************				 * Add all bar tags				 **********************/				var barCenter:Number = leftX + barWidth / 2;								//Families				var familiesString:String = commaNumber(families) + " families";								textBlock.text = familiesString;				textBlock.setTextFormat(reg6Format);				textBlock.width = 4 * (squareWidth * squaresWide - squareMargin * 2);				tempData = new BitmapData(textBlock.width, 32, false, 0x666666);				textBoxOffset = new Point(leftX + squareMargin, stripTop - barHeight - 17);				tempData.draw(textBlock, new Matrix(1, 0, 0, 1, 0, 1));								byteData = new ByteArray;				byteData = PNGEncoder.encode(tempData, 1);				byteData.position = 0;								outputPDF.addImageStream(byteData, textBoxOffset.x, textBoxOffset.y, tempData.width / 4, tempData.height / 4);								//*************draw boxes				for (var n:int = 0; n < squaresHigh; n++) {					//trace(familySquares, squaresWide);					var squaresInLine:int = Math.min(familySquares, squaresWide);										for (var o:int = 0; o < squaresInLine; o++) {						outputPDF.lineStyle(new RGBColor(chartColors[i]), 0.001);						outputPDF.beginFill(new RGBColor(chartColors[i]));						outputPDF.drawRect(new Rectangle(leftX + squareWidth * o + squareMargin, stripTop - squareWidth * n - squareMargin * 2, squareWidth - squareMargin * 2, -squareWidth + squareMargin * 2));						outputPDF.endFill();					}					familySquares -= squaresInLine;				}											}			return (familyCount);		}				protected function drawText(incomes:Array, families:int):void {						/***********************			 Add Text			 ***********************/						//Set variables			var textYear:String = this.year.toString();			var boroughName:String = incomes[0].name == '' ? incomes[0].borough : incomes[0].name;			var BOROUGHNAME:String = boroughName.toLocaleUpperCase();			boroughName = spaceToQuestion(boroughName);			var MFI:int = incomes[0].medianIncome;			var MFIString:String = commaNumber(MFI);			var percentMFI:int = MFI / this.mainMFI;			var familiesString:String = commaNumber(families);			var calculatedIncome:int = estimatedRent * 12 / .3;			var calculatedIncomeString:String = commaNumber(calculatedIncome);									//Create Strings			var finalText:String = "";			var finalTextVarStarts:Array = [];			var finalTextVarEnds:Array = [];			var finalTextQuestions:Array = [];						var pageTitle:String = (estimatedRent > 0) ? "INCOME AND RENT IN " : "INCOME IN ";			var pageCredits:String = "CENTER FOR URBAN PEDAGOGY";			var webAddress:String = "WWW.ENVISIONINGDEVELOPMENT.NET";						var textArray:Array = [				"",				boroughName+ " - " + textYear, 				"\n\n", 				"$" + MFIString, 				" - MFI (", percentMFI + "%", " of NYC METRO AREA!MFI)\n"];						var textArray2:Array = ["$" + estimatedRent, " - your estimated rent for a 2-bedroom apartment in " + boroughName + "\n",				"$" + calculatedIncomeString, " - minimum annual income to meet government standards* for affordable housing\n"];			var textArray3:Array = ["\n1 square equals " + squareValue + " families."];						if (estimatedRent > 0) {				textArray = textArray.concat(textArray2);				textArray3[0] += "\n*The government defines affordable housing as costing less than 30% of the occupying family's income.";			}						textArray = textArray.concat(textArray3);						var len:int = textArray.length;			for (var i:int = 0; i < len; i++) {				finalText += textArray[i];								if (i % 2 == 0) {					finalTextVarStarts.push(finalText.length);				}				else {					finalTextVarEnds.push(finalText.length);				}			}						len = finalText.length;			for (i = 0; i < len; i++) {				if (finalText.charAt(i) == '!')					finalTextQuestions.push(i);			}						var plainTextFormat:TextFormat = new TextFormat(defaultFontName, 48, 0x000000, null, null, null, null, null, null, 100, null, -100);			var creditTextFormat:TextFormat = new TextFormat(defaultFontName, 36, 0x000000);			var varTextFormat:TextFormat = new TextFormat(defaultBoldName, 48, defaultVariableColor);			var spaceTextFormat:TextFormat = new TextFormat(defaultBoldName, 48, 0xffffff);			var titleTextFormat:TextFormat = new TextFormat(defaultFontName, 96, 0x000000);			var titleVarTextFormat:TextFormat = new TextFormat(defaultBoldName, 96, defaultVariableColor, null, null, null, null, null, null, null, null, 10);						var textBlock:TextField = new TextField;						textBlock.width = textBoxDim.x * 4 - textMargin * 4;			textBlock.height = textBoxDim.y * 4;			textBlock.wordWrap = true;			textBlock.multiline = true;			textBlock.embedFonts = true;						textBlock.text = finalText;			textBlock.setTextFormat(plainTextFormat);						len = finalTextVarEnds.length;			for (i = 0; i < len; i++) {				textBlock.setTextFormat(varTextFormat, finalTextVarStarts[i], finalTextVarEnds[i]);			}						textBlock.setTextFormat(creditTextFormat, finalTextVarStarts[len - 1], finalTextVarEnds[len - 1]);						len = finalTextQuestions.length;			for (i = 0; i < len; i++) {				textBlock.setTextFormat(spaceTextFormat, finalTextQuestions[i], finalTextQuestions[i] + 1);			}									textBoxDim.y = (textBlock.textHeight + 10) / 4;			var tempData:BitmapData = new BitmapData(textBoxDim.x * 4, textBoxDim.y * 4 + 25, false, 0xffffff);			tempData.draw(textBlock, new Matrix(1, 0, 0, 1, textOffset.x * 4, textOffset.y * 4 + 25));						var byteData:ByteArray = new ByteArray;			byteData = PNGEncoder.encode(tempData, 1);			//byteData = PNGEnc.encode(tempData,1);			byteData.position = 0;									//var textBoxOffset:Point = new Point(pageDimensions.x - margin - chartMargin - textBoxDim.x,margin + titleHeight +chartMargin);			var textBoxOffset:Point = new Point(margin + chartMargin, margin + titleHeight + chartMargin);			outputPDF.addImageStream(byteData, textBoxOffset.x, textBoxOffset.y, textBoxDim.x, textBoxDim.y);									//Borough Name						textBlock.width = 2400;						textBlock.text = pageTitle + BOROUGHNAME;			textBlock.setTextFormat(titleVarTextFormat);						tempData = new BitmapData(2400, 75, false, 0xffffff);//			tempData.draw(textBlock, new Matrix(1, 0, 0, 1, -12, -150));			tempData.draw(textBlock, new Matrix(1, 0, 0, 1, -12, 1));						byteData = new ByteArray;			byteData = PNGEncoder.encode(tempData, 1);			byteData.position = 0;						textBoxOffset = new Point(margin, margin - 5);			outputPDF.addImageStream(byteData, textBoxOffset.x, textBoxOffset.y, tempData.width / 4, tempData.height / 4);						//Credit						textBlock.width = 2000;						textBlock.text = pageCredits;			textBlock.setTextFormat(creditTextFormat);			textBlock.embedFonts = true;						tempData = new BitmapData(600, 36, false, 0xffffff);			tempData.draw(textBlock, new Matrix(1, 0, 0, 1, 0, 1));						byteData = new ByteArray;			byteData = PNGEncoder.encode(tempData, 1);			byteData.position = 0;						textBoxOffset = new Point(652, margin - 5);			outputPDF.addImageStream(byteData, textBoxOffset.x, textBoxOffset.y, tempData.width / 4, tempData.height / 4);						//web address						textBlock.width = 2000;						textBlock.text = webAddress;			textBlock.setTextFormat(creditTextFormat);			textBlock.embedFonts = true;						tempData = new BitmapData(600, 36, false, 0xffffff);			tempData.draw(textBlock, new Matrix(1, 0, 0, 1, 0, 1));						byteData = new ByteArray;			byteData = PNGEncoder.encode(tempData, 1);			byteData.position = 0;						textBoxOffset = new Point(627, margin + 5);			outputPDF.addImageStream(byteData, textBoxOffset.x, textBoxOffset.y, tempData.width / 4, tempData.height / 4);					}				protected function drawMask():void {			/***********************			 DRAW THE MASK			 ***********************/			var mapMargins:int = 36;						outputPDF.lineStyle(new RGBColor(0xffffff));			outputPDF.beginFill(new RGBColor(0xffffff));						outputPDF.drawRect(new Rectangle(0, 0, mapMargins, 612));			outputPDF.drawRect(new Rectangle(0, 0, 792, mapMargins + titleHeight));			outputPDF.drawRect(new Rectangle(792 - mapMargins, 0, mapMargins, 612));			outputPDF.drawRect(new Rectangle(0, 612 - mapMargins, 792, mapMargins));			outputPDF.endFill();		}		protected function savePDF():void {						var boroughNumber:String = selectedBoroughs[0];			var boroPrefixIndex:int = parseInt(boroughNumber.substr(0, 1));			trace('prefix', boroPrefixIndex, boroughPrefixes[boroPrefixIndex]);			var pdfName:String = (selectedBoroughs.length == 1) ? boroughPrefixes[boroPrefixIndex] + "_" + boroughNumber.substr(1, 2) : boroughPrefixes[boroPrefixIndex];			outputPDF.save(Method.REMOTE, this.printURL, Download.INLINE, pdfName + ".pdf");			info.dispatchEvent(new Event(Event.COMPLETE));		}				private function readBoroughs(e:Event):void {			var rawXML:XMLList = XMLList(svgLoader.data);						for each (var item:XML in rawXML.elements()) {				recursiveParse(item);			}			createPDF();		}				private function recursiveParse(xml:XML):void {			var tempID:String = xml.@id.toString();			if (tempID.substr(0, 17) == "sub_x5F_boro_x5F_" || tempID == "background") {								workingBorough = tempID.substring(tempID.length - 3, tempID.length);				outlineDict[workingBorough] = new BoroughData(workingBorough);				if (workingBorough != "und") {					outlineList.push(workingBorough);				}			}						var tempPoints:String = xml.@points.toString();			if (tempPoints != "") {				var tempBoroughData:BoroughData = outlineDict[workingBorough];				tempBoroughData.addPoints(tempPoints);				outlineDict[workingBorough] = tempBoroughData;			}						for each (var att:XML in xml.attributes()) {				var attName:String = att.toString();				if (attName.substr(0, 4) == "#sub") {					attName = attName.substr(18, 3);					tempBoroughData = outlineDict[attName];					tempBoroughData.setTranslate(xml.@transform);				}			}						if (xml.children() != xml) {				for each (var item:XML in xml.children()) {					recursiveParse(item);				}			}		}						private function commaNumber(plainNumber:int):String {			var numberString:String = plainNumber.toString();						if (plainNumber < 1000) {							}			else if (plainNumber < 1000000) {				numberString = numberString.substr(0, numberString.length - 3) + "," + numberString.substr(numberString.length - 3, 3);			}			else {				numberString = numberString.substr(0, numberString.length - 6) + "," + numberString.substr(numberString.length - 6, 3) + "," + numberString.substr(numberString.length - 3, 3);			}						return numberString;		}				private function drawPolyOutline(points:Array, translation:Point, fillColor:uint = 0xffffff, lineWeight:Number = 0, lineColor:uint = 0x000000):void {						var tempPolyPoints:Array = [];			for each (var p:Point in points) {				if (p.x) {					tempPolyPoints.push((p.x) * scale + offset.x);					tempPolyPoints.push((p.y) * scale + offset.y);				}			}									outputPDF.lineStyle(new RGBColor(lineColor), lineWeight);// set the line style color			outputPDF.beginFill(new RGBColor(fillColor));			outputPDF.drawPolygone(tempPolyPoints);			outputPDF.endFill();		}				private function spaceToQuestion(s:String):String {			var spacePattern:RegExp = / /g;			var q:String = s.replace(spacePattern, '!');			return (q);		}		}}