package ru.ngl.utils 
{
	import flash.external.ExternalInterface;
	import flash.utils.getTimer;
	/**
	 * ...
	 * @author Alexander Semikolenov 
	 */
	public class Console 
	{
		
		public function Console() 
		{
			
		}
		
		// STATIC METHODS
		
		static public function log(...arg):void
		{
			CONFIG::debug
			{
				log2.apply(null, arg);
			}
		}
		static public function log2(...arg):void
		{
			var str:String = "[flash"
			CONFIG::debug
			{
				var num:int = getTimer()
				str += " " + Conversion.secondToHMS(num) + "::" + num % 1000;
			}
			str+="] " + arg.join(" ");
			try
			{
				if (ExternalInterface.available) 
				{ 
					ExternalInterface.call("console.log", str);
				}
			}catch (err:Error) { }
			trace(str);
		}
		static public function logErr(...arg):void
		{
			var str:String = "[flash err] "+arg.join(" ");
			try
			{
				if (ExternalInterface.available) 
				{ 
					ExternalInterface.call("console.log", str);
				}
			}catch (err:Error) { }
			trace(str);
		}
		static public function logAd(...arg):void
		{
			var str:String = "[flash ad] "+arg.join(" ");
			try
			{
				if (ExternalInterface.available) 
				{ 
					ExternalInterface.call("console.log", str);
				}
			}catch (err:Error) { }
			trace(str);
		}
		// ACCESSORS
		
		// PUBLIC METHODS
		
		// EVENT HANDLERS
		
		// PRIVATE METHODS
		
	}

}