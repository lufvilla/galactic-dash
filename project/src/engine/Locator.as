package engine
{
	import flash.display.Sprite;
	import flash.display.Stage;
	
	public class Locator extends Sprite
	{
		public static var mainStage:Stage;
		
		public static var console:Console;
		public static var assetsManager:AssetsManager;
		public static var screenManager:ScreenManager;
		public static var inputManager:InputManager;
		public static var updateManager:UpdateManager;
		public static var saveManagerPro:SaveManagerPro;
		
		public function Locator()
		{
			mainStage = stage;
			
			updateManager = new UpdateManager();
			console = new Console();
			assetsManager = new AssetsManager();
			screenManager = new ScreenManager();
			inputManager = new InputManager();
			saveManagerPro = new SaveManagerPro();
			
			trace("*** Engine Initialized ***");
		}
	}
}