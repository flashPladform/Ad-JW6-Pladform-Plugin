package ru.ngl.popup 
{
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	/**
	 * ...
	 * @author Ngl
	 */
	public class ResizebleObject extends EventDispatcher 
	{
		public var x			:Number = 0;
		public var y			:Number = 0;
		public var width		:Number = 0;
		public var height		:Number = 0;
		
		private var oldX		:Number = 0;
		private var oldY		:Number = 0;
		private var oldWidth	:Number	= 0;
		private var oldHeight	:Number	= 0;
		
		private var _stage		:Stage;
		
		public function set stage(val:Stage):void
		{
			_stage = val;
			_stage.addEventListener(Event.RESIZE, resizeHandler)
			resizeHandler(null);
		}
		
		public function get stage():Stage
		{
			return _stage;
		}
		
		public function ResizebleObject() 
		{
		}
		
		private function resizeHandler(e:Event):void 
		{
			x = 0;
			y = 0;
			width	= stage.stageWidth;
			height	= stage.stageHeight-y;
			dispatchEvent(new Event(Event.RESIZE));
		}
	}

}