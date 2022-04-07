package
{
	import engine.Locator;
	import engine.Screen;
	
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.sampler.NewObjectSample;
	import flash.ui.Keyboard;

	public class ScreenLevel1 extends Screen
	{
		// Jugador y enemigos
		public var character:Character;
		public var enemy:MovieClip;
		public var enemySpeed:Number = 1.5;
		public var isEnemyMoving:Boolean = false;
		
		// Elementos del mapa
		public var map:MovieClip;
		public var allMap:Vector.<MovieClip> = new Vector.<MovieClip>;
		public var spawnPoint:Point = new Point();
		public var enemySpawn:Point = new Point();
		
		// "Camara"
		public var cameraStartLimit:int = 100;
		
		
		public function ScreenLevel1()
		{
			super("MCLevel1");
			
			map = this.model;
			
			this.init();
		}
		
		private function init():void
		{
			loadMap();
		}
		
		override public function onUpdate():void
		{
			if(Game.instance.isGameRunning)
			{
				character.update();
				if(isEnemyMoving) enemy.y -= enemySpeed;
				checkCollisions();
				simulateCamera();
			}
		}
		
		private function loadMap():void
		{
			allMap = new Vector.<MovieClip>();
			
			for (var i:int = 0; i < this.model.numChildren; i++) 
			{
				if(this.model.getChildAt(i).name == "mc_platform")
				{
					this.model.getChildAt(i).alpha = 0;
					allMap.push(this.model.getChildAt(i));
				}
				else if(this.model.getChildAt(i).name == "mc_spawnpoint")
				{
					this.model.getChildAt(i).alpha = 0;
					spawnPoint.x = this.model.getChildAt(i).x;
					spawnPoint.y = this.model.getChildAt(i).y;
				}
				else if(this.model.getChildAt(i).name == "mc_plasmaBall")
				{
					allMap.push(this.model.getChildAt(i));
				}
				else if(this.model.getChildAt(i).name == "mc_enemy")
				{
					enemy = MovieClip(this.model.getChildAt(i));
					enemy.alpha = 0;
					enemySpawn.x = enemy.x;
					enemySpawn.y = enemy.y;
				}
				else if(this.model.getChildAt(i).name == "mc_camstart" )
				{
					allMap.push(this.model.getChildAt(i));
				}
				else if(this.model.getChildAt(i).name == "mc_final" )
				{
					allMap.push(this.model.getChildAt(i));
				}
				else if(this.model.getChildAt(i).name == "mc_character" )
				{
					character = new Character(MovieClip(this.model.getChildAt(i)));
				}
			}
		}
		
		public function checkCollisions():void
		{
			if(enemy.hitTestObject(character.model) && isEnemyMoving && !Game.instance.isGod)
			{
				this.goTo = Levels.GAMEOVER;
				return;
			}
			else if(map.getChildByName("mc_enemystart").hitTestObject(character.model))
			{
				isEnemyMoving = true;
				enemy.alpha = 0.7;
				map.getChildByName("mc_enemystart").alpha = 0;
			}
			else
			{
				for (var i:int = 0; i < allMap.length; i++) 
				{
					if(allMap[i].name == "mc_plasmaBall")
					{
						if(allMap[i].hitTestObject(character.model) && allMap[i].alpha != 0)
						{
							allMap[i].alpha = 0;
							Game.instance.soundPlasmaController.play();
							Game.instance.soundPlasmaController.volume = 0.2;
							break;
						}
					}
					else if(allMap[i].name == "mc_platform")
					{
						if(character.dirY == -1 && allMap[i].hitTestObject(character.model.mc_hitTop))
						{
							character.model.y = allMap[i].y + allMap[i].height + character.model.height/2;
							character.dirY = 0;
							character.model.mc_body.rotation = 180;
							break;
						}
						else if(character.dirY == 1 && allMap[i].hitTestObject(character.model.mc_hitBot))
						{
							character.model.y = allMap[i].y - character.model.height/2;
							character.dirY = 0;
							character.model.mc_body.rotation = 0;
							break;
						}
						else if(character.dirX == 1 && allMap[i].hitTestObject(character.model.mc_hitFront))
						{
							character.model.x = allMap[i].x - character.model.width/2;
							character.dirX = 0;
							character.model.mc_body.rotation = -90;
							break;
						}
						else if(character.dirX == -1 && allMap[i].hitTestObject(character.model.mc_hitBack))
						{
							character.model.x = allMap[i].x + character.model.width/2 + allMap[i].width;
							character.dirX = 0;
							character.model.mc_body.rotation = 90;
							break;
						}
					}
					else if(allMap[i].name == "mc_final" && allMap[i].hitTestObject(character.model.mc_hitTop))
					{
						this.goTo = Levels.LEVEL2;
						return;
					}
				}
			}
		}
		
		public function simulateCamera():void
		{
			var pos:Number = -character.model.y + Locator.mainStage.stageHeight/2;
			if(cameraStartLimit < pos) map.y = pos;
		}
	}
}