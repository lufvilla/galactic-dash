package engine
{
	import flash.events.Event;

	public class UpdateManager
	{
		public var allUpdates:Vector.<Function> = new Vector.<Function>();
		
		public function UpdateManager()
		{
			trace("Initializing UpdateManager...");
			
			Locator.mainStage.addEventListener(Event.ENTER_FRAME, evUpdate);
		}
		
		public function addFunction(f:Function):void
		{
			var index:int = allUpdates.indexOf(f);
			if(index == -1)
			{
				allUpdates.push(f);
			}
		}
		
		public function removeFunction(f:Function):void
		{
			var index:int = allUpdates.indexOf(f);
			if(index != -1)
			{
				allUpdates.splice(index, 1);
			}
		}
		
		protected function evUpdate(event:Event):void
		{
			for (var i:int = 0; i < allUpdates.length; i++) 
			{
				allUpdates[i](event);
			}
			
		}
	}
}