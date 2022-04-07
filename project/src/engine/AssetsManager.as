package engine
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.media.Sound;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	
	[Event(name="complete", type="flash.events.Event")]
	public class AssetsManager extends EventDispatcher
	{
		public var loaderLinks:URLLoader;
		
		public var allAssets:Dictionary = new Dictionary();
		public var allSWFs:Vector.<Loader> = new Vector.<Loader>();
		
		public var allURLsOfTexts:Vector.<String> = new Vector.<String>();
		
		public var linksForLoad:Array = new Array();
		public var linksForLoadNames:Array = new Array();
		
		public var preload:MCPreload = new MCPreload();
		public var assetsLoaded:int;
		public var assetsTotal:int;
		
		public function AssetsManager()
		{
			trace("Inicializando Precarga...");
		}
		
		public function loadLinks(url:String):void
		{
			Locator.mainStage.addChild(preload);
			//preload.mc_current.gotoAndStop(1);
			preload.mc_global.gotoAndStop(1);
			
			loaderLinks = new URLLoader();
			loaderLinks.dataFormat = URLLoaderDataFormat.VARIABLES;
			loaderLinks.load(new URLRequest(url));
			loaderLinks.addEventListener(Event.COMPLETE, evFileWithLinksComplete);
		}
		
		protected function evFileWithLinksComplete(event:Event):void
		{
			
			for(var varName:String in loaderLinks.data)
			{
				
				var link:String = loaderLinks.data[varName];
				var escapedLink:String = escape(link);
				var cleanedLink:String = escapedLink.split("%0A")[0];
				
				linksForLoad.push(cleanedLink);
				linksForLoadNames.push(varName);
			}
			
			
			assetsTotal = linksForLoad.length;
			
			trace(linksForLoad);
			
			loadAsset(linksForLoad[0], linksForLoadNames[0]);
		}
		
		public function loadAsset(link:String, name:String):void
		{
			
			var realLink:String = "engine/" + link;
			
			var folder:String = link.split("/")[0];
			
			
			switch(folder)
			{
				case "images":
					var loaderImages:Loader = new Loader();
					loaderImages.load(new URLRequest(realLink));
					loaderImages.contentLoaderInfo.addEventListener(Event.COMPLETE, evAssetComplete);
					loaderImages.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, evError);
					loaderImages.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, evProgress);
					allAssets[name] = loaderImages;
					break;
				
				case "sounds":
					var loaderSounds:Sound = new Sound();
					loaderSounds.load(new URLRequest(realLink));
					loaderSounds.addEventListener(Event.COMPLETE, evAssetComplete);
					loaderSounds.addEventListener(IOErrorEvent.IO_ERROR, evError);
					loaderSounds.addEventListener(ProgressEvent.PROGRESS, evProgress);
					allAssets[name] = loaderSounds;
					break;
				
				case "texts":
					var loaderTexts:URLLoader = new URLLoader();
					loaderTexts.load(new URLRequest(realLink));
					loaderTexts.addEventListener(Event.COMPLETE, evAssetComplete);
					loaderTexts.addEventListener(IOErrorEvent.IO_ERROR, evError);
					loaderTexts.addEventListener(ProgressEvent.PROGRESS, evProgress);
					allAssets[name] = loaderTexts;
					allURLsOfTexts.push(link);
					break;
				
				case "swfs":
					var loaderSWF:Loader = new Loader();
					loaderSWF.load(new URLRequest(realLink));
					loaderSWF.contentLoaderInfo.addEventListener(Event.COMPLETE, evAssetComplete);
					loaderSWF.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, evError);
					loaderSWF.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, evProgress);
					allSWFs.push(loaderSWF);
					break;
			}
		}
		
		protected function evProgress(event:ProgressEvent):void
		{
			//trace(event.bytesLoaded, event.bytesTotal);
			var percentage:int = event.bytesLoaded * 100 / event.bytesTotal;
			//preload.mc_current.gotoAndStop(percentage);
		}
		
		protected function evError(event:IOErrorEvent):void
		{
			Locator.console.open();
			Locator.console.writeLn("There was an error loading...");
		}
		
		protected function evAssetComplete(event:Event):void
		{
			trace("1 Asset Loaded...");
			
			
			assetsLoaded++;
			
			
			var percentage:int = assetsLoaded * 100 / assetsTotal;
			preload.mc_global.gotoAndStop(percentage);
			
			
			event.currentTarget.removeEventListener(Event.COMPLETE, evAssetComplete);
			event.currentTarget.removeEventListener(ProgressEvent.PROGRESS, evProgress);
			event.currentTarget.removeEventListener(IOErrorEvent.IO_ERROR, evError);
			
			
			linksForLoad.splice(0, 1);
			linksForLoadNames.splice(0, 1);
			
			
			if(linksForLoad.length > 0)
			{
				
				loadAsset(linksForLoad[0], linksForLoadNames[0]);
			}else
			{
				Locator.mainStage.removeChild(preload);
				dispatchEvent(new Event(Event.COMPLETE));
			}
		}
		
		public function getImage(name:String):Bitmap
		{
			
			var myLoader:Loader = allAssets[name];
			if(myLoader != null)
			{
				
				var bmpTemp:Bitmap;
				
				
				var bmpDataTemp:BitmapData;
				
				
				bmpDataTemp = new BitmapData(myLoader.width, myLoader.height, true, 0x000000);
				
				
				bmpDataTemp.draw(myLoader);
				
				
				bmpTemp = new Bitmap(bmpDataTemp);
				
				return bmpTemp;
			}
			
			return null;
		}
		
		public function getSound(name:String):Sound
		{
			return allAssets[name];
		}
		
		public function getText(name:String):String
		{
			 
			return allAssets[name] != null ? allAssets[name].data : null;
		}
		
		public function getMovieClip(name:String):MovieClip
		{
			for (var i:int = 0; i < allSWFs.length; i++) 
			{
				try
				{
					var myClass:Class = allSWFs[i].contentLoaderInfo.applicationDomain.getDefinition(name) as Class;
					return new myClass();
				}catch(e1:ReferenceError)
				{
					
				}
			}
			
			
			return null;
		}
	}
}