
import flash.display.MovieClip;
import flash.events.MouseEvent;
import flash.net.URLRequest;
import flash.net.navigateToURL;

import gs.TweenLite;
stop();

var paramList:Object = this.root.loaderInfo.parameters;

home.useHandCursor = true;
home.buttonMode = true;
home.addEventListener(MouseEvent.CLICK, onHomeClick);

function onHomeClick(event:MouseEvent):void
{
	goto('http://envisioningdevelopment.net');
}

var firstBubble:MovieClip;
var secondBubble:MovieClip;

var firstText:String =  paramList.hasOwnProperty('first') ? paramList['first'] : '';
var secondText:String = paramList.hasOwnProperty('second') ? paramList['second'] : '';
var firstLink:String =  paramList.hasOwnProperty('firstLink')  ? paramList['firstLink']  : '';
var secondLink:String = paramList.hasOwnProperty('secondLink') ? paramList['secondLink'] : '';

// initializing text
firstBubble.text.text = firstText.toUpperCase();
if (firstBubble.text.textHeight > 140)
{
	firstBubble.bg.scaleY = (firstBubble.text.textHeight + 90) / 260;
	firstBubble.text.height = firstBubble.text.textHeight + 20;
}
else if (firstBubble.text.textHeight < 120)
{
	firstBubble.text.y = ((225 / 2) - (firstBubble.text.textHeight/2)) + 37;
}

firstBubble.more.y = firstBubble.text.y + firstBubble.text.textHeight + 10; 
firstBubble.close.y = firstBubble.text.y + firstBubble.text.textHeight + 10;

secondBubble.text.text = secondText.toUpperCase();
if (secondBubble.text.textHeight > 140)
{
	secondBubble.bg.scaleY = (secondBubble.text.textHeight + 90) / 225;
	secondBubble.text.height = secondBubble.text.textHeight + 20;
}
else if (secondBubble.text.textHeight < 120)
{
	secondBubble.text.y = (225 / 2) - (secondBubble.text.textHeight/2);
}

secondBubble.y = firstBubble.y + firstBubble.height - 3;
secondBubble.more.y = secondBubble.text.y + secondBubble.text.textHeight + 10; 
secondBubble.close.y = secondBubble.text.y + secondBubble.text.textHeight + 10;

// scale them down for animation 
firstBubble.x = firstBubble.width/2;
firstBubble.scaleX = firstBubble.scaleY = 0;
firstBubble.visible = false;
secondBubble.x = secondBubble.width/2;
secondBubble.scaleX = secondBubble.scaleY = 0;
secondBubble.visible = false;

// animate them up
if (firstText.length)
{
	firstBubble.visible = true;
	TweenLite.to(firstBubble, .2, {delay:.5, scaleX:1, scaleY:1, x:1});	
}

if (secondText.length)
{
	secondBubble.visible = true;
	TweenLite.to(secondBubble, .2, {delay:.75, scaleX:1, scaleY:1, x:1});
}

// adding event listeners
firstBubble.more.addEventListener(MouseEvent.CLICK, onMoreClick);
firstBubble.close.addEventListener(MouseEvent.CLICK, onFirstClose);

//interactivity
firstBubble.more.addEventListener(MouseEvent.ROLL_OVER, onOver);
firstBubble.more.addEventListener(MouseEvent.ROLL_OUT, onOut);
firstBubble.close.addEventListener(MouseEvent.ROLL_OVER, onOver);
firstBubble.close.addEventListener(MouseEvent.ROLL_OUT, onOut);

secondBubble.more.addEventListener(MouseEvent.CLICK, onMoreClick);
secondBubble.close.addEventListener(MouseEvent.CLICK, onSecondClose);

// interactivity
secondBubble.more.addEventListener(MouseEvent.ROLL_OVER, onOver);
secondBubble.more.addEventListener(MouseEvent.ROLL_OUT, onOut);
secondBubble.close.addEventListener(MouseEvent.ROLL_OVER, onOver);
secondBubble.close.addEventListener(MouseEvent.ROLL_OUT, onOut);

function onFirstClose(event:MouseEvent):void
{
	TweenLite.to(firstBubble, .2, {scaleX:0, scaleY:0, x:firstBubble.width/2});
	TweenLite.to(secondBubble, .2, {y:firstBubble.y + 37});
}

function onSecondClose(event:MouseEvent):void
{
	TweenLite.to(secondBubble, .2, {scaleX:0, scaleY:0, x:secondBubble.width/2});
}

function onOver(event:MouseEvent):void
{
	event.currentTarget.alpha = 1;
}

function onOut(event:MouseEvent):void
{
	event.currentTarget.alpha = .5;
}

function onMoreClick(event:MouseEvent):void
{
	if (event.target.parent == firstBubble)
	{
		goto(firstLink);
	}
	else if (event.target.parent == secondBubble)
	{
		goto(secondLink);
	}
}

function goto(url:String):void
{
	navigateToURL(new URLRequest(url), '_self');
}