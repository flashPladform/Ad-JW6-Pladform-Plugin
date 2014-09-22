package ru.pladform.adloader 
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.Security;
	import flash.system.SecurityDomain;
	import ru.pladform.adloader.event.ModuleLoadEvent;
	import ru.pladform.PladformAdWrapper;
	/**
	 * ...
	 * @author Alex Semikolenov (alex.semikolenov@gmail.com)
	 */
	public class AdLoader extends EventDispatcher
	{
		private const MODULE_PATH:String = "http://static.pladform.ru/pladformAdvertModule.swf";
		
		private var loader:Loader;
		
		public function AdLoader() 
		{
			loader = new Loader();
		}
		
		// STATIC METHODS
 		
		// ACCESSORS
		
		// PROTECTED METHODS
		
		// PUBLIC METHODS
		/**
		 * Загружаем рекламынй модуль
		 */
		public function load():void
		{
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeLoadHandler);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, errLoadHandler);
			loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, errLoadHandler);
			/*var context :LoaderContext	= new LoaderContext(true, ApplicationDomain.currentDomain);
			if (Security.sandboxType != Security.LOCAL_TRUSTED)
			{
				context.securityDomain = SecurityDomain.currentDomain;
			}*/
			loader.load(new URLRequest(MODULE_PATH)/*,context*/);
		}
		// EVENT HANDLERS
		/**
		 * Загрузка успешно зачершена
		 * @param	e
		 */
		private function completeLoadHandler(e:Event):void 
		{
			dispatchEvent(new ModuleLoadEvent(ModuleLoadEvent.LOAD_COMPLETE, new PladformAdWrapper(e.target.content)));
		}
		/**
		 * Любые порблемы с загрузкой рекламного модуля
		 * @param	e
		 */
		private function errLoadHandler(e:Event):void 
		{
			dispatchEvent(new ModuleLoadEvent(ModuleLoadEvent.LOAD_ERROR, null));
		}
		
		// PRIVATE METHODS
		
	}

}