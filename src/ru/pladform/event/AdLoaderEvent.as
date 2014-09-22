package ru.pladform.event 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Alex Semikolenov (alex@semikolenov.ru)
	 * 
	 * События загрузки информации о рекламе
	 */
	public class AdLoaderEvent extends Event 
	{
		/**
		 *	Загрузка информации о рекламе завершена
		 */
		static public const COMPLETE:String = "AdLoaderEvent.COMPLETE";
		/**
		 * При загрузке информации о рекламе произошла ошибка
		 */
		static public const ERROR	:String = "AdLoaderEvent.ERROR";
		
		public function AdLoaderEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
		} 
		
		public override function clone():Event 
		{ 
			return new AdLoaderEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("AdLoaderEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
	}
	
}