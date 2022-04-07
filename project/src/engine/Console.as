package engine
{
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.utils.Dictionary;
	
	public class Console
	{
		public var model:MCConsole;
		public var keyForOpenConsole:int;
		public var isOpened:Boolean;
		public var allCommands:Dictionary = new Dictionary();
		
		public function Console()
		{
			model = new MCConsole();
			
			keyForOpenConsole = Keyboard.F8;
			
			Locator.updateManager.addFunction(evUpdate);
			model.tb_input.addEventListener(FocusEvent.FOCUS_OUT,evFocusOut);
			
			registerCommand("clear", clear, "Cleans what you wrote.", 0);
			registerCommand("help", help, "Well... it helps?", 0);
			registerCommand("exit", exit, "You leave.", 0);
			registerCommand("quit", exit, "Same as exit.", 0);
		}
		
		private function evFocusOut(event:FocusEvent):void
		{
			if(isOpened)
			{
				Locator.mainStage.focus = model.tb_input;
			}
		}
		
		private function evUpdate(event:Event):void
		{
			if(Locator.inputManager.getKeyDown(keyForOpenConsole))
			{
				!isOpened ? open() : close();
				isOpened = !isOpened;
				
			}
			else if(isOpened && Locator.inputManager.getKeyDown(Keyboard.ENTER))
			{
					execCommand();
					model.tb_input.text = "";				
			}
		}
		
		public function clear():void
		{
			model.tb_log.text = "";
		}
		
		public function exit():void
		{
			
		}
		
		public function help():void
		{
			writeLn("List of commands:");
			writeLn("");
			for(var varName:String in allCommands)
			{
				writeLn(varName + " : " + allCommands[varName].description);
			}
		}
		
		public function write(text:String):void
		{
			model.tb_log.text += text;
			model.tb_log.scrollV = model.tb_log.numLines;
		}
		
		public function writeLn(text:String):void
		{
			write(text + "\n");
		}
		
		public function registerCommand(name:String, command:Function, description:String, numArgs:int):void
		{
			var cData:CommandData = new CommandData();
			cData.command = command;
			cData.name = name;
			cData.description = description;
			cData.numArgs = numArgs;
			
			allCommands[name] = cData;
		}
		
		public function unregisterCommand(name:String):void
		{
			delete allCommands[name];
		}
		
		public function execCommand():void
		{
			var textParsed:Array = model.tb_input.text.split(" ");
			var commandName:String = textParsed[0];
			var temp:CommandData = allCommands[commandName];
			
			textParsed.splice(0, 1);
			
			if(temp != null)
			{
				try
				{
					temp.command();
				}catch(e1:ArgumentError)
				{
					try
					{
						temp.command.apply(this, textParsed);
					}catch(e3:ArgumentError)
					{
						writeLn("Incorrect amount of parameters. Was expecting " + temp.numArgs + (temp.numArgs > 1 ? " parameters." : " parameter."));
					}
				}catch(e2:Error)
				{
					writeLn("Bad error. Message: " + e2.message);
				}finally
				{
					
				}
			}
			else
			{
				writeLn("Invalid Command");
			}
		}
		
		public function open():void
		{
			Locator.mainStage.addChild(model);
			Locator.mainStage.focus = model.tb_input;
		}
		
		public function close():void
		{
			Locator.mainStage.removeChild(model);
			Locator.mainStage.focus = Locator.mainStage;
		}
	}
}