package engine
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.Dictionary;
	
	import engine.com.lia.crypto.AES;

	public class SaveManagerPro
	{
		public var dataLoaded:Dictionary;
		public var saver:FileStream;
		
		public const LOCATION:String = "GlacticDash/saves/";
		public const SAVE_NAME:String = "GD01.sav";
		
		public var file:File;
		
		public function SaveManagerPro()
		{
			trace("Inicializando SaveManager ►PRO");
			file = File.documentsDirectory.resolvePath(LOCATION + SAVE_NAME);
		}
		
		public function save(allData:Dictionary):void
		{
			saver = new FileStream();
			saver.open(file, FileMode.WRITE);
			
			var parsed:String = "";
			for(var varName:String in allData)
			{
				parsed += varName + "=" + allData[varName] + ";\n";
			}
			
			saver.writeUTFBytes(parsed);
			saver.close();
		}
		
		public function load():void
		{
			saver = new FileStream();
			saver.open(file, FileMode.READ);
			
			var parsed:String = saver.readUTFBytes(saver.bytesAvailable);
			var splittedData:Array = escape(parsed).split("%3B%0A");
			dataLoaded = new Dictionary();
			for (var i:int = 0; i < splittedData.length; i++) 
			{
				var lineSplitted:Array = splittedData[i].split("%3D");
				var varName:String = lineSplitted[0];
				var value:String = lineSplitted[1];
				dataLoaded[varName] = value;
			}
		}
		
		public function saveObject(allData:Dictionary):void
		{
			saver = new FileStream();
			saver.open(file, FileMode.WRITE);
			saver.writeObject(allData);
			saver.close();
		}
		
		public function loadObject():void
		{
			saver = new FileStream();
			saver.open(file, FileMode.READ);
			dataLoaded = saver.readObject();
			saver.close();
		}
		
		public function saveEncrypted(allData:Dictionary):void
		{
			var tempData:Dictionary = new Dictionary();
			
			for(var varName:String in allData)
			{
				var encryptedVarName:String = AES.encrypt(varName, "1234567", AES.BIT_KEY_256);
				var encryptedValue:String = AES.encrypt(allData[varName], "1234567", AES.BIT_KEY_256);
				
				tempData[encryptedVarName] = encryptedValue;
			}
			
			saveObject(tempData);
		}
		
		public function loadEncrypted():void
		{
			loadObject();
			
			var tempData:Dictionary = new Dictionary();
			for(var varName:String in dataLoaded)
			{
				var encryptedVarName:String = AES.decrypt(varName, "1234567", AES.BIT_KEY_256);
				var encryptedValue:String = AES.decrypt(dataLoaded[varName], "1234567", AES.BIT_KEY_256);
				
				//trace(encryptedVarName);
				
				tempData[encryptedVarName] = encryptedValue;
			}
			
			dataLoaded = tempData;
		}
	}
}