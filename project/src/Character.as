package 
{
	import engine.Locator;
	
	import flash.display.MovieClip;
	import flash.ui.Keyboard;

	public class Character
	{
		public var model:MovieClip;
		public var currentScale:Number = 0.5;
		
		public var isDead:Boolean 	= false;
		public var isLocked:Boolean = false;
		
		public var speed:int = 15;
		public var dirX:int;
		public var dirY:int;
		
		public var lives:int = 3;
		
		public function Character(model:MovieClip)
		{
			this.model = model;
			
			spawn();
		}
		
		public function spawn():void
		{			
			model.mc_hitBot.alpha 	= 0;
			model.mc_hitTop.alpha 	= 0;
			model.mc_hitFront.alpha = 0;
			model.mc_hitBack.alpha 	= 0;
		}
		
		public function update():void
		{
			move();
		}
		
		public function move():void
		{
			if(dirX == 0 && dirY == 0)
			{
				if(Locator.inputManager.getKeyDown(Keyboard.W) && model.mc_body.rotation != 180)
				{
					model.mc_body.rotation = 0;
					dirY = -1;
					moveSound();
				}
				else if (Locator.inputManager.getKeyDown(Keyboard.D) && model.mc_body.rotation != -90)
				{
					model.mc_body.rotation = 90;
					dirX = 1;
					moveSound();
				}
				else if (Locator.inputManager.getKeyDown(Keyboard.S) && model.mc_body.rotation != 0)
				{
					model.mc_body.rotation = 180;
					dirY = 1;
					moveSound();
				}
				else if (Locator.inputManager.getKeyDown(Keyboard.A) && model.mc_body.rotation != 90)
				{
					model.mc_body.rotation = -90;
					dirX = -1;
					moveSound();
				}
			}
			
			model.y += speed * dirY;
			model.x += speed * dirX;
		}
		
		public function moveSound():void
		{
			Game.instance.soundMoveController.play();
			Game.instance.soundMoveController.volume = 0.4;
		}
		
		public function die():void
		{
			this.isDead = true;
			this.model.alpha = 0;
		}
	}
}