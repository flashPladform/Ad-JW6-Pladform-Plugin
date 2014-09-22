package ru.pladform.adloader.event {
	import flash.events.Event;
	import ru.pladform.PladformAdWrapper;
	
	/**
	 * ...
	 * @author Alex Semikolenov (alex.semikolenov@gmail.com)
	 */
	public class ModuleLoadEvent extends Event 
	{
		static public const LOAD_COMPLETE	:String = "ModuleLoadEvent.LOAD_COMPLETE";
		static public const LOAD_ERROR		:String = "ModuleLoadEvent.LOAD_ERROR";
		
		private var _adWrapper:PladformAdWrapper;
		
		public function ModuleLoadEvent(type:String,adWrapper:PladformAdWrapper, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			_adWrapper	= adWrapper;
		} 
		
		public function get adWrapper():PladformAdWrapper 
		{
			return _adWrapper;
		}
		
		public override function clone():Event 
		{ 
			return new ModuleLoadEvent(type, _adWrapper, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("ModuleLoadEvent", "adWrapper", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
		
		
	}
	
}