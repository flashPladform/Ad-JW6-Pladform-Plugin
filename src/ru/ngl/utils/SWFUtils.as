package ru.ngl.utils 
{
	import flash.display.DisplayObject;
	import flash.errors.IllegalOperationError;
	/**
	 * ...
	 * @author Alexander Semikolenov
	 */
	public class SWFUtils 
	{
		static private var isInit:Boolean;
		static private var rootClip:DisplayObject;
		static private var _swfLocatin:String = null;
		
		public function SWFUtils() { }
		
		// STATIC METHODS
		static public function init(rootClip:DisplayObject):void
		{
			SWFUtils.rootClip = rootClip;
			if (rootClip)
			{
				isInit = true;
			}
			else
			{
				isInit = false;
				_swfLocatin = null
			}
		}
		/**
		 * Получение урла расположения swf файла
		 */
		static public function get swfLocatin():String
		{
			if (!isInit)
			{
				throw new IllegalOperationError("SWFUtils is not init")
			}
			if (!_swfLocatin)
			{
				var ar:Array = rootClip.loaderInfo.url.split("/")
				ar.splice(ar.length - 1, 1)
				_swfLocatin = ar.join("/")
			}
			return _swfLocatin;
		}
		// ACCESSORS
		
		// PUBLIC METHODS
		
		// PROTECTED METHODS
		
		// EVENT HANDLERS
		
		// PRIVATE METHODS
		
	}

}