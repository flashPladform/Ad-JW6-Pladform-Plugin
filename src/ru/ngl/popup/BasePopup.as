package ru.ngl.popup 
{
	import com.greensock.TweenNano;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;
	import ru.ngl.event.PopupEvent;
	import ru.ngl.utils.ResizeObject;
	
	/**
	 * ...
	 * @author	Ngl
	 * @version	1.0.0
	 * @date	2010-12-12
	 */
	public class BasePopup extends MovieClip
	{
		static public var ANIMATION_TIME:Number	= .5;
		/**
		 * Тип попапа определяющий его нахождение в стеке попапов
		 * */
		public var type	: String;
		
		public function set resizeObj(obj:ResizeObject):void
		{
			resObj = obj;
			resObj.addEventListener(Event.RESIZE, resizeHendler)
			//resObj.addEventListener(Event.FULLSCREEN, resizeHendler)
			resizeHendler();
			
		}
		/**
		 * Описание контента
		 */
		public function get description():Object
		{
			return obj;
		}
		public function set description(obj:Object):void
		{
			this.obj = obj;
			
		}
		
		private var obj	: Object;
		private var resObj:ResizeObject;
		/**
		 * @param description Описание контента
		 * @param type Тип попапа определяющий его нахождение в стеке попапов
		 * */
		public function BasePopup(description:Object=null, type:String=PopupType.SERVICE) 
		{
			this.description	= description;
			this.type			= type;
			
			if (stage)
			{
				initHandler();
				return;
			}
			addEventListener(Event.ADDED_TO_STAGE, initHandler);
		}
		
		//PUBLIC
		/**
		 * Открыть попап
		 */
		public function show():void
		{
			TweenNano.to(this, ANIMATION_TIME, { alpha:1 } );
		}
		
		public function hide(isForcibly:Boolean = false):void
		{
			TweenNano.to(this, ANIMATION_TIME, { alpha:0, onComplete:hideComplete, onCompleteParams:[isForcibly]} );
		}
		
		//PROTECTED
		protected function resizeHendler(e:Event=null):void 
		{
			//this.x	= resObj.x + 0.5 * (resObj.width - this.width);
			//this.y	= resObj.y + 0.5 * (resObj.height - this.height);
		}
		
		//PRIVATE
		private function initHandler(e:Event=null):void 
		{
			this.alpha	= 0;
			addEventListener(Event.REMOVED_FROM_STAGE, removeHandler);
			
			if (resObj)
			{
				resizeObj = resObj;
			}
			//stage.addEventListener(Event.RESIZE, resizeHendler)
			//resizeHendler();
		}
		
		private function removeHandler(e:Event):void 
		{
			//removeEventListener(Event.ADDED_TO_STAGE, initHandler);
			removeEventListener(Event.REMOVED_FROM_STAGE, removeHandler);
			stage.removeEventListener(Event.RESIZE, resizeHendler)
		}
		
		private function hideComplete(isForcibly:Boolean):void
		{
			
			if (isForcibly)
			{
				dispatchEvent(new PopupEvent(PopupEvent.FORCIBLY_CLOSED, type, description));
			}
			else
			{
				dispatchEvent(new PopupEvent(PopupEvent.CLOSED, type, description));
			}
		}
	}

}