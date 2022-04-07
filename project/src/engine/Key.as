package engine
{
	import flash.events.Event;

	public class Key
	{
		public var isPress:Boolean;
		public var wasPressed:Boolean;
		public var wasReleased:Boolean;
		public var code:int;
		
		public var speed:Number = 0.01;
		public var currentValue:Number = 0;
		
		public function Key(code:int)
		{
			this.code = code;
		}
		
		public function press():void
		{
			isPress = true;
			wasPressed = true;
			
			//Locator.mainStage.addEventListener(Event.ENTER_FRAME, evMarkWasPressed);
			Locator.updateManager.addFunction(evMarkWasPressed);
			Locator.updateManager.addFunction(evIncreaseValue);
			Locator.updateManager.removeFunction(evDecreaseValue);
		}
		
		private function evIncreaseValue(event:Event):void
		{
			currentValue += speed;
			if(currentValue >= 1)
			{
				currentValue = 1;
				Locator.updateManager.removeFunction(evIncreaseValue);
			}
		}
		
		protected function evMarkWasPressed(event:Event):void
		{
			wasPressed = false;
			//Locator.mainStage.removeEventListener(Event.ENTER_FRAME, evMarkWasPressed);
			Locator.updateManager.removeFunction(evMarkWasPressed);
		}
		
		public function release():void
		{
			isPress = false;
			wasReleased = true;
			
			//Locator.mainStage.addEventListener(Event.ENTER_FRAME, evMarkWasReleased);
			Locator.updateManager.addFunction(evMarkWasReleased);
			Locator.updateManager.addFunction(evDecreaseValue);
			Locator.updateManager.removeFunction(evIncreaseValue);
		}
		
		private function evDecreaseValue(event:Event):void
		{
			currentValue -= speed;
			if(currentValue <= 0)
			{
				currentValue = 0;
				Locator.updateManager.removeFunction(evDecreaseValue);
			}
		}
		
		protected function evMarkWasReleased(event:Event):void
		{
			wasReleased = false;
			//Locator.mainStage.removeEventListener(Event.ENTER_FRAME, evMarkWasReleased);
			Locator.updateManager.removeFunction(evMarkWasReleased);
		}
		
		public function toString():String
		{
			return code.toString();
		}
	}
}