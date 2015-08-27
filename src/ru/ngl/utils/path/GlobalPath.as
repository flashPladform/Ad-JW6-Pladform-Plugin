package ru.ngl.utils.path
{
	import flash.display.DisplayObject;
	/**
	 * @author Ngl
	 * @version 1.0.0
	 * @date 2010-11-17
	 * 
	 * Is Singletone pattern
	 * 
	 * GlobalPath - класс определяющий место положения запускаемого swf, исходя из чего возврящает пути к сайту и скрипту на сервере. Если определяется локальное расположение swf, то подставляется имя тестового сервера определенное в <b>testPath</b>.
	 */
	public class GlobalPath
	{
		
		private var sitePath	:String;										// Путь к сайту

		private var testPath	:String		= "http://partner.pladform.ru/";		// Путь к тестовому серверу
		private var scriptPath	:String		= "";						// Путь к серверному скрипту относительно корня сайты
		private var is_active	:Boolean	= false;						// Статус инициализации класса
		
		static private var item:GlobalPath	= new GlobalPath();
		
		static public function getIt():GlobalPath 
		{
			return item;
		}
		
		public function GlobalPath() 
		{
			if (item) throw new Error("GlobalPath Class single tone");
		}
		
		/**
		 *@param rootClip клип определяющий место положения swf-ки.
		 */
		public function init(rootClip:DisplayObject = null):void
		{
			var mc:DisplayObject	=  rootClip;
			if (!is_active)
			{
				if (mc.root)
				{
					if (mc.root.loaderInfo.url.substr(0, 5) == "file:")
					{
						sitePath	= "";
					}
					else
					{
						sitePath	= testPath;
					}
					
					is_active	= true;
				}
				else
				{
					throw new Error("Error (init failed): Parameter has no reference to Root");
				}
			}
		}
		
		/**
		 * Путь к сайту
		 */
		public function get site():String
		{
			if (!is_active)
			{
				throw new Error("Error: No init)");
			}
			
			return sitePath;
		}
		
		
		/**
		 * Путь к скрипту
		 */
		public function get script():String
		{
			if (!is_active)
			{
				throw new Error("Error: No init)");
			}
			
			return sitePath + scriptPath;
		}
		
	}

}