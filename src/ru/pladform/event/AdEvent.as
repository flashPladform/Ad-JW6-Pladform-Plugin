package ru.pladform.event 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Alexander Semikolenov (alex@semikolenov.ru)
	 * 
	 * События передаваемые от рекламы
	 */
	public class AdEvent extends Event 
	{
		/**
		 * Начало показа рекламы
		 */
		static public const SHOW			:String	= "AdEvent.SHOW";
		/**
		 * Закрытие рекламы пользователем
		 */
		static public const CLOSE			:String	= "AdEvent.CLOSE";
		/**
		 * Завершение рекламы
		 */
		static public const COMPLETE		:String	= "AdEvent.COMPLETE";
		/**
		 * Отсутствие рекламы, в том числе из-за ошибок
		 */
		static public const EMPTY			:String	= "AdEvent.EMPTY";
		/**
		 * Клик по рекламе 
		 */
		static public const CLICK			:String	= "AdEvent.CLICK";
		
		public var isAfterVPAIDClick:Boolean;
		
		public function AdEvent(type:String, isAfterVPAIDClick:Boolean=false, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			this.isAfterVPAIDClick = isAfterVPAIDClick;
		} 
		
		public override function clone():Event 
		{ 
			return new AdEvent(type, isAfterVPAIDClick, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("AdEvent", "type", "isAfterVPAIDClick", "bubbles", "cancelable", "eventPhase"); 
		}
		
		
		
	}
	
}