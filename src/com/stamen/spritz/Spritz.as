package com.stamen.spritz
{
	import com.marstonstudio.UploadPostHelper;
	import com.adobe.images.PNGEncoder;
	
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.KeyboardEvent;
	import flash.events.SecurityErrorEvent;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.utils.ByteArray;

	public class Spritz extends Sprite
	{
		public function Spritz() 
		{
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyUp);
		}
		
		private function onKeyUp(event:KeyboardEvent):void
		{
			if (event.ctrlKey && event.shiftKey && String.fromCharCode(event.keyCode) == "5") {
				postSnap(this, "http://studio.stamen.com/spritz/post.php", postComplete, postError, null);
			}
		}
		
		private function postComplete(event:Event):void
		{
			var url:String = event.target.data;
			if (url != "0") {
				try {
					flash.net.navigateToURL(new URLRequest(url), "_new");
				}
				catch (error:Error) {
					showError("no url found in response, maybe something went wrong?");
				}
			}
			else {
				showError("error posting to spritz, try again?");
			}	
		}

		private function postError(event:Event):void
		{
			showError(event.target.data);
		}
		
		private function showError(error:String):void
		{
			trace(error);
		}

		// this guy did *all* the work, really:
		// http://marstonstudio.com/index.php/2007/08/19/how-to-take-a-snapshot-of-a-flash-movie-and-automatically-upload-the-jpg-to-a-server-in-three-easy-steps/
		public static function postSnap(target:DisplayObject, uploadPath:String, onComplete:Function, onError:Function, parameters:Object=null):void
		{
			var bitmapData:BitmapData = new BitmapData(target.width, target.height, true, 0xFFFFFF);
			var drawingRectangle:Rectangle =  new Rectangle(0, 0, target.width, target.height);
			bitmapData.draw(target, new Matrix(), null, null, drawingRectangle, false);

			var byteArray:ByteArray = PNGEncoder.encode(bitmapData);

			var fileName:String = flash.utils.getQualifiedClassName(target) + ".png"; //"desiredfilename.jpg"

			var urlRequest:URLRequest = new URLRequest();
			urlRequest.url = uploadPath;
			urlRequest.contentType = 'multipart/form-data; boundary=' + UploadPostHelper.getBoundary();
			urlRequest.method = URLRequestMethod.POST;
			urlRequest.data = UploadPostHelper.getPostData(fileName, byteArray, parameters) as Object;
			urlRequest.requestHeaders.push( new URLRequestHeader( 'Cache-Control', 'no-cache' ) );
			
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
			urlLoader.addEventListener(Event.COMPLETE, onComplete);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, onError);
			urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
			try {
				urlLoader.load(urlRequest);
			}
			catch(error:Error) {
				onError(new ErrorEvent(error.name, false, false, error.message));
			}
		}
		
	}
}