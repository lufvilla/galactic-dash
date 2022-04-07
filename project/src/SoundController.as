package 
{
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	
	public class SoundController
	{
		public var snd:Sound;
		public var channel:SoundChannel;
		public var settings:SoundTransform;
		public var lastPosition:Number;
		
		public function SoundController(snd:Sound)
		{
			this.snd = snd;
		}
		
		public function play(start:int = 0):void
		{
			start *= 1000;
			settings = new SoundTransform(1, 0);
			channel = snd.play(start, 0, settings);
			
			if(channel != null)
				channel.addEventListener(Event.SOUND_COMPLETE, evSoundComplete);
			else
				throw new Error("No se detecto el dispositivo de sonido...");
		}
		
		protected function evSoundComplete(event:Event):void
		{
			
		}
		
		public function stop():void
		{
			channel.stop();
		}
		
		public function pause():void
		{
			lastPosition = channel.position;
			channel.stop();
		}
		
		public function resume():void
		{
			channel = snd.play(lastPosition, 0, settings);
		}
		
		public function set volume(value:Number):void
		{
			settings.volume = value;
			channel.soundTransform = settings;
		}
		
		public function get volume():Number
		{
			return settings.volume;
		}
		
		public function set pan(value:Number):void
		{
			settings.pan = value;
			channel.soundTransform = settings;
		}
		
		public function get pan():Number
		{
			return settings.pan;
		}
	}
}