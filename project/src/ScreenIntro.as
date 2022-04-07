package
{
	import engine.Screen;
	
	import flash.events.Event;

	public class ScreenIntro extends Screen
	{
		public function ScreenIntro()
		{
			super("MCPantallaIntro");
			
			this.next = Levels.LEVEL1
			this.model.addEventListener("EndIntro",onIntroEnd);
		}
		
		private function onIntroEnd(e:Event):void
		{
			this.nextScreen();
		}
	}
}