package engine
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.Dictionary;

	public class ScreenManager
	{
		public var allScreens:Dictionary = new Dictionary();
		public var currentScreen:Screen;
		
		public var containerScreens:Sprite;
		public var containerTransition:Sprite;
		
		public var transition:MovieClip;
		
		public var nextScreenToLoad:String;
		
		public function ScreenManager()
		{
			trace("Inicializando ScreenManager...");
			
			containerScreens = new Sprite();
			containerTransition = new Sprite();
			Locator.mainStage.addChild(containerScreens);
			Locator.mainStage.addChild(containerTransition);
			
			Locator.updateManager.addFunction(evUpdate);
		}
		
		protected function evUpdate(event:Event):void
		{
			if(currentScreen != null)
			{
				if(currentScreen.goTo != null)
				{
					loadScreen( currentScreen.goTo );
				}
				else
				{
					currentScreen.onUpdate();
				}
			}
		}
		
		public function registerScreen(name:String, scr:Class):void
		{
			allScreens[name] = scr;
		}
		
		public function loadScreen(name:String):void
		{
			nextScreenToLoad = name;
			
			if(transition == null)
			{
				evNowLoadScreen(null);
			}
			else
			{
				containerTransition.addChild(transition);
				transition.addEventListener("NowLoadScreen", evNowLoadScreen);
				transition.play();
			}
		}
		
		public function reloadScreen():void
		{
			this.loadScreen(currentScreen.name);
		}
		
		protected function evNowLoadScreen(event:Event):void
		{
			if(currentScreen != null)
			{
				currentScreen.onExit();
				currentScreen = null;
			}
			
			var scrClass:Class = allScreens[nextScreenToLoad];
			currentScreen = new scrClass();
			currentScreen.addEventListener(ScreenEvent.CHANGE, evChange);
			currentScreen.onEnter();
			
			//transition.play();
		}
		
		protected function evChange(event:ScreenEvent):void
		{
			currentScreen.removeEventListener(ScreenEvent.CHANGE, evChange);
			loadScreen(event.targetScreen);
		}
	}
}