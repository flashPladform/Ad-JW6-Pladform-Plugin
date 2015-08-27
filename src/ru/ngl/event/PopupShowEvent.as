package ru.ngl.event 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author 	Ngl
	 */
	public class PopupShowEvent extends Event 
	{
		static public const SHOW:String = "PopupShowEvent.SHOW"
		public function PopupShowEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new PopupShowEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("PopupShowEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}