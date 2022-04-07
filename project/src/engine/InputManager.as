package engine
{
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.utils.Dictionary;

	public class InputManager
	{
		public var keys:Array = new Array();
		public var keysByName:Dictionary = new Dictionary();
		
		public var sequence:Array = new Array();
		
		public var timeToCleanSequence:int = 500;
		public var currentTimeToCleanSequence:int = timeToCleanSequence;
		
		public function InputManager()
		{
			trace("Inicializando InputManager...");
			
			Locator.mainStage.addEventListener(KeyboardEvent.KEY_UP, evKeyUp);
			Locator.mainStage.addEventListener(KeyboardEvent.KEY_DOWN, evKeyDown);
			
			Locator.updateManager.addFunction(evUpdate);
		}
		
		private function evUpdate(event:Event):void
		{
			/*currentTimeToCleanSequence -= 1000 / Locator.mainStage.frameRate;
			if(currentTimeToCleanSequence <= 0)
			{
				currentTimeToCleanSequence = timeToCleanSequence;
				sequence = new Array();
			}*/
		}
		
		protected function evKeyDown(event:KeyboardEvent):void
		{
			//keys[event.keyCode] = true;
			var k:Key = keys[event.keyCode];
			if(k == null)
			{
				k = new Key(event.keyCode);
				keys[event.keyCode] = k;
			}
			
			if(!k.isPress)
			{
				k.press();
				sequence.push(k);
				currentTimeToCleanSequence = timeToCleanSequence;
			}
		}
		
		protected function evKeyUp(event:KeyboardEvent):void
		{
			//keys[event.keyCode] = false;
			var k:Key = keys[event.keyCode];
			if(k == null)
			{
				k = new Key(event.keyCode);
				keys[event.keyCode] = k;
			}
			
			k.release();
		}
		
		public function setRelation(name:String, code:int):void
		{
			var k:Key = keys[code];
			if(k == null)
			{
				k = new Key(code);
				keys[code] = k;
			}
			
			keysByName[name] = k;
		}
		
		public function getKey(code:int):Boolean
		{
			return keys[code] != null ? keys[code].isPress : false;
		}
		
		public function getKeyDown(code:int):Boolean
		{
			return keys[code] != null ? keys[code].wasPressed : false;
		}
		
		public function getKeyUp(code:int):Boolean
		{
			return keys[code] != null ? keys[code].wasReleased : false;
		}
		
		public function getKeyValue(code:int):Number
		{
			return keys[code] != null ? keys[code].currentValue : 0;
		}
		
		public function getKeyValueByName(name:String):Number
		{
			return keysByName[name] != null ? keysByName[name].currentValue : 0;
		}
		
		public function compareSequence(s:Array):Boolean
		{
			return sequence.toString().indexOf( s.toString() ) != -1;
		}
	}
}