package ru.ngl.event 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Ngl
	 */
	public class PopupEvent extends Event 
	{
		static public const CLOSED			:String = "PopupEvent CLOSED";
		static public const FORCIBLY_CLOSED	:String = "PopupEvent FORCIBLY_CLOSED";
		
		public var popupType		:String;
		public var description		:Object;
		public function PopupEvent(type:String, popupType:String, description:Object = null, bubbles:Boolean = false, cancelable:Boolean = false)
		{ 
			super(type, bubbles, cancelable);
			this.popupType		= popupType;
			this.description	= description;
		} 
		
		public override function clone():Event 
		{ 
			return new PopupEvent(type, popupType, description, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("PopupEvent", "type", "popupType", "description", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}