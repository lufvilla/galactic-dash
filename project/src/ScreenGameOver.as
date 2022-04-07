package
{
	import engine.Locator;
	import engine.Screen;
	
	import flash.ui.Keyboard;

	public class ScreenGameOver extends Screen
	{
		public function ScreenGameOver()
		{
			super("MCGameOver");
		}
		
		override public function onUpdate():void
		{
			if(Locator.inputManager.getKeyDown(Keyboard.R))
			{
					this.goTo = "level1";
			}
		}
	}
}