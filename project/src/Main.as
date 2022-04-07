package 
{
	import engine.Locator;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	
	[SWF(width="1024", height="768", frameRate="60", backgroundColor="0x000000")]
	public class Main extends Locator
	{
		public function Main() 
		{
			Locator.assetsManager.loadLinks("assets.txt");
			Locator.assetsManager.addEventListener(Event.COMPLETE, evStartGame);
		}
		
		private function evStartGame(event:Event):void
		{
			// Inicia el juego :3
			new Game();
		}
	}
}