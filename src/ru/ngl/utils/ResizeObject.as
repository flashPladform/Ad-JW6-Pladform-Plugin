package ru.ngl.utils
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	/**
	 * @private
	 * 
	 * @eventType flash.events.Event.RESIZE
	 *  
	 *  @langversion 3.0
	 */
	[Event(name="resize", type="flash.events.Event")] 
	
	/**
	 * ResizeObject представляет из себя прямоугольник, у которого можно изменять размер и положение, при этом генерируя события изменения.
	 * @author Alexander Semikolenov 
	 */
	public class ResizeObject extends EventDispatcher 
	{
		private var _x		:Number;
		private var _y		:Number;
		private var _width	:Number;
		private var _height	:Number;
		
		public function ResizeObject() 
		{
			
		}
		
		// STATIC METHODS
 		
		// ACCESSORS
		/**
		 * Высота прямоугольника
		 */
		public function set height(value:Number):void
		{
			_height = value;
			dispatchEvent(new Event(Event.RESIZE));
		}
		public function get height():Number 
		{
			return _height;
		}
		/**
		 * Ширина прямоугольника
		 */
		public function set width(value:Number):void
		{
			_width = value;
			dispatchEvent(new Event(Event.RESIZE));
		}
		public function get width():Number 
		{
			return _width;
		}
		
		public function set y(value:Number):void
		{
			_y = value;
			dispatchEvent(new Event(Event.RESIZE));
		}
		public function get y():Number 
		{
			return _y;
		}
		
		public function set x(value:Number):void
		{
			_x = value;
			dispatchEvent(new Event(Event.RESIZE));
		}
		public function get x():Number 
		{
			return _x;
		}
		
		// PUBLIC METHODS
		/**
		 * Изменение сразу нескольких параметров
		 * @param	x
		 * @param	y
		 * @param	width
		 * @param	height
		 */
		public function update(x:Number, y:Number, width:Number, height:Number):void
		{
			if	(
				_x		!= x ||
				_y		!= y ||
				_width	!= width ||
				_height	!= height
				)
			{
				_x = x ;
				_y = y ;
				_width = width;
				_height = height;
				dispatchEvent(new Event(Event.RESIZE));
			}
		}
		
		override public function toString():String
		{
			return "{x:" + x + ", y:" + y + ", width:" + width + ", height:" + height + "}";
		}
		
		// EVENT HANDLERS
		
		// PRIVATE METHODS
		
	}

}