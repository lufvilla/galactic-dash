package engine
{
	import flash.display.MovieClip;
	import flash.events.EventDispatcher;

	[Event(name="change", type="engine.ScreenEvent")]
	[Event(name="enter", type="engine.ScreenEvent")]
	[Event(name="exit", type="engine.ScreenEvent")]
	[Event(name="update", type="engine.ScreenEvent")]
	public class Screen extends EventDispatcher
	{
		public var model:MovieClip;
		public var goTo:String;
		public var next:String;
		public var name:String
		
		public function Screen(name:String)
		{
			this.name = name;
			model = Locator.assetsManager.getMovieClip(name);
		}
		
		public function onEnter():void
		{
			Locator.screenManager.containerScreens.addChild(model);	
		}
		
		public function onUpdate():void
		{
			
		}
		
		public function onExit():void
		{
			Locator.screenManager.containerScreens.removeChild(model);
			model = null;
		}
		
		public function nextScreen():void
		{
			this.goTo = this.next;
		}
		
		public function change(name:String):void
		{
			var myEvent:ScreenEvent = new ScreenEvent( ScreenEvent.CHANGE );
				myEvent.targetScreen = name;
				myEvent.parameters = ["Sarasa", "Otro Sarasa"];
			
			dispatchEvent(myEvent);
		}
	}
}