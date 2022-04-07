package 
{
	import engine.Locator;

	public class Game
	{
		// Game.instance SingleTown?
		public static var instance:Game;
		
		// Musica y sonidos
		public var musicController:SoundController;
		public var soundMoveController:SoundController;
		public var soundPlasmaController:SoundController;
		
		// Variables del juego
		public var isGameRunning:Boolean = false;
		public var isGod:Boolean = false;
		
		
		public function Game()
		{
			Game.instance = this;
			
			// Sonidos
			soundMoveController 	= new SoundController(Locator.assetsManager.getSound("sndMove"));
			soundPlasmaController 	= new SoundController(Locator.assetsManager.getSound("sndPlasma"));
			musicController 		= new SoundController(Locator.assetsManager.getSound("sndBackground"));
			musicController.play();
			
			
			// Consola
			Locator.console.registerCommand("togglegod", toggleGodMode, "Pone el juego en una dificultad para que lo pases. :3", 0);
			
			// Registramos todas las pantallas del juego
			Locator.screenManager.registerScreen(Levels.LEVEL1, ScreenLevel1);
			Locator.screenManager.registerScreen(Levels.LEVEL2, ScreenLevel2);
			Locator.screenManager.registerScreen(Levels.LEVEL3, ScreenLevel3);
			Locator.screenManager.registerScreen(Levels.GAMEOVER, ScreenGameOver);
			Locator.screenManager.registerScreen(Levels.INTRO, ScreenIntro);
			
			// Llamamos a la primera pantalla
			Locator.screenManager.loadScreen(Levels.INTRO);
			isGameRunning = true;
		}
		
		private function toggleGodMode():void
		{
			isGod = !isGod;
			if(isGod)
				Locator.console.writeLn("Ya podes pasar el nivel :3");
			else
				Locator.console.writeLn("Its rape time");
		}
		
		
		private function restartMap():void
		{
			Locator.screenManager.reloadScreen();
		}
	}
}