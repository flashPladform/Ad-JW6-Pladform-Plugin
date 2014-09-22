package ru.pladform{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLVariables;
	import ru.pladform.event.AdEvent;
	import ru.pladform.event.AdLoaderEvent;
	import ru.pladform.IPladformModule;
	/**
	 * ...
	 * @author Alexander Semikolenov (alex@semikolenov.ru)
	 * 
	 * Обертка над рекоамным модулем
	 */
	public class PladformAdWrapper extends Sprite implements IPladformModule
	{
		private var obj:Object;
		
		public function PladformAdWrapper(obj:Object) 
		{
			this.obj = obj;
			var ed:EventDispatcher = obj as EventDispatcher
			trace("ed = ",ed)
			if (ed)
			{
				ed.addEventListener(AdEvent.SHOW, eventHandlers);
				ed.addEventListener(AdEvent.CLOSE, eventHandlers);
				ed.addEventListener(AdEvent.COMPLETE, eventHandlers);
				ed.addEventListener(AdEvent.CLICK, eventHandlers);
				ed.addEventListener(AdEvent.EMPTY, eventHandlers);
				
				ed.addEventListener(AdLoaderEvent.COMPLETE, eventHandlers);
				ed.addEventListener(AdLoaderEvent.ERROR, eventHandlers);
			}
			addChild(obj as DisplayObject)
		}
		// STATIC METHODS
		
		// ACCESSORS
		
		// PUBLIC METHODS
		/**
		 * Инициализация модуля перед началом показа видеоролика, параметры передаются через объект URLVariables, который, параметры которого участвуют в запросе рекламы. 
		 * @param	vars передаваемые параметры в формате URLVariables.Свойство pl в vars является обязательным
		 */
		public function init(vars:URLVariables):void
		{
			if (obj)
			{
				obj.init(vars)
			}
		}
		
		// PROTECTED METHODS
		
		// EVENT HANDLERS
		
		private function eventHandlers(e:Object):void 
		{
			var someEventClassName:String = e.type.split(".")[0];
			
			switch(someEventClassName)
			{
				case "AdEvent":
				{
					dispatchEvent(new AdEvent(e.type,e.isAfterVPAIDClick));
					break;
				}
				case "AdLoaderEvent":
				{
					dispatchEvent(new AdLoaderEvent(e.type));
					break;
				}
			}
		}
		
		// PRIVATE METHODS
	}

}