package ru.ngl.popup 
{
	import com.greensock.TweenNano;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import ru.ngl.event.PopupEvent;
	import ru.ngl.utils.ResizeObject;
	/**
	 * ...
	 * @author Ngl
	 * @version 1.0.0
	 * @date 2011.08.01
	 * 
	 * AbstractPopup - абстрактный класс управления попапами.
	 * 
	 * Попапы для удобства разделены на 2 типа:
	 * PopupType.LOGICAL - попап несущий в себе какую-либо логику, основная его отличительная особенность, что при закрытии его любым другим логическим попапом, к нему есть возможность вернуться.
	 * PopupType.SERVICE - не несет внутри себя никакой логики, предназначен в основном для отображения сервисных сообщений ( например: ошибка ввода), в случае если данный попап будет закрыт появлением любого другого попапа, вернуться к нему будет нельзя.
	 */
	public class AbstractPopup 
	{
		public var popup					: BasePopup;
		
		protected var substrateColorARGB	:uint	= 0x96000000;
		protected  var resizeObject		:ResizeObject;
		
		private var popupContainer			: DisplayObjectContainer;
		private var arPopup					: Array;
		private var resizeDispatcher:EventDispatcher;
		protected var spSubstrate				: Sprite;
		
		
		
		public function AbstractPopup() 
		{
			arPopup = new Array();
		}
		
		/**
		 * Задается контейнер для отображения попапа
		 */
		public function container(dispObjC:DisplayObjectContainer, resizeDispatcher:EventDispatcher):void
		{
			this.resizeDispatcher = resizeDispatcher;
			popupContainer = dispObjC;
			if (resizeDispatcher)
			{
				initHandler();
				return;
			}
			
			popupContainer.addEventListener(Event.ADDED_TO_STAGE, initHandler);
		}
		
		/**
		 * Показать попап
		 * @param	name имя попапа, определяющее класс для отображения
		 * @param	obj объек с даннми необходимыми для инициализации попапа
		 * @param	type тип попапа, PopupType.LOGICAL или PopupType.SERVICE
		 */
		public function show(name:String, obj:Object = null, type:String = "Popup type is logical"):BasePopup
		{
			if ((arPopup.length > 0)||(popup!=null))
			{
				popup.hide(true);
			}
			if (popupContainer && popupContainer.parent)
			{
				var par:DisplayObjectContainer = popupContainer.parent
				par.swapChildren(popupContainer, par.getChildAt(par.numChildren-1));
			}
			popup = getPopup(name, obj, type);
			popup.resizeObj = resizeObject;
			
			if (arPopup.length == 0)
			{
				spSubstrate.alpha	= 0;
			}
			spSubstrate.visible	= true;
			TweenNano.to(spSubstrate, BasePopup.ANIMATION_TIME, { alpha:1 } );
			
			if (arPopup.length == 0)
			{
				popup.show();
			}
			
			if (type == PopupType.LOGICAL)
			{
				arPopup.push(popup);
			}
			
			popupContainer.addChild(popup)
			popup.addEventListener(PopupEvent.CLOSED, popupClosedHandler)
			popup.addEventListener(PopupEvent.FORCIBLY_CLOSED, popupForciblyClosedHandler);
			
			return popup
		}
		
		/**
		 * Закрыть попап
		 */
		public function hide():void
		{
			if (popup)
			{
				popup.hide();
			}
		}
		
		/**
		 * Закрыть попап, вемсте с цепочкой попапов, вызвавших данный
		 */
		public function hideAll():void
		{
			if (popup)
			{
				var num:int = (popup.type == PopupType.LOGICAL) ? 1 : 0;
				while (arPopup.length > num)
				{
					var mc:BasePopup = BasePopup(arPopup.shift());
					popupContainer.removeChild(mc);
				}
				popup.hide();
			}
		}
		
		//-=PROTECTED=-
		/**
		 *  Получение попапа по его имени с заданными атрибутами
		 * @param	name имя попапа, определяющее класс для отображения
		 * @param	obj объек с даннми необходимыми для инициализации попапа
		 * @param	type тип попапа, PopupType.LOGICAL или PopupType.SERVICE
		 * @return запрашиваемый попап
		 */
		protected function getPopup(name:String, obj:Object, type:String):BasePopup
		{
			throw new Error("getPopup is abstract function, must override!");
		}
		
		protected function resizeHendler(e:Event = null):void 
		{
			spSubstrate.x		= resizeObject.x;
			spSubstrate.y		= resizeObject.y;
			spSubstrate.width	= resizeObject.width;
			spSubstrate.height	= resizeObject.height;
		}
		private function resizeHendler2(e:Event = null):void 
		{
			var target:Object = e.currentTarget
			
			if (target is ResizeObject)
			{
				resizeObject.update(target.x,target.y,target.width,target.height)
			}
			else if (target is Stage)
			{
				resizeObject.update(0,0,target.stageWidth,target.stageHeight)
			}
			
			
			
		}
		//-=PRIVATE=-
		private function initHandler(e:Event = null):void 
		{
			spSubstrate 		= new Sprite();
			var bmd	:BitmapData	= new BitmapData(100, 100, true, substrateColorARGB);
			var bm	:Bitmap		= new Bitmap(bmd);
			popupContainer.addChild(spSubstrate)
			spSubstrate.addChild(bm);
			spSubstrate.visible = false;
			resizeObject = new ResizeObject();
			resizeObject.addEventListener(Event.RESIZE, resizeHendler)
			
			if(resizeDispatcher) resizeDispatcher.addEventListener(Event.RESIZE, resizeHendler2)
			
			//resizeObject.stage = popupContainer.stage;
			
			
			popupContainer.addEventListener(Event.REMOVED_FROM_STAGE, removeHandler);
			//popupContainer.stage.addEventListener(Event.RESIZE, stageResizeHendler)
			
			//resizeHendler();
		}
		
		private function removeHandler(e:Event):void 
		{
			popupContainer.removeEventListener(Event.ADDED_TO_STAGE, initHandler);
			popupContainer.removeEventListener(Event.REMOVED_FROM_STAGE, removeHandler);
			popupContainer.stage.removeEventListener(Event.RESIZE, resizeHendler)
		}
		
		private function popupForciblyClosedHandler(e:PopupEvent):void 
		{
			popup.show();
			var targ:BasePopup = BasePopup(e.currentTarget)
			if (targ.type != PopupType.LOGICAL)
			{
				popupContainer.removeChild(targ);
			}
		}
		
		private function popupClosedHandler(e:PopupEvent):void 
		{
			if (popup.type == PopupType.LOGICAL)
			{
				arPopup.pop();
			}
			popupContainer.removeChild(popup);
			if (arPopup.length > 0)
			{
				popup = arPopup[arPopup.length - 1];
				popup.show();
			}
			else
			{
				popup = null;
				TweenNano.to(spSubstrate, BasePopup.ANIMATION_TIME, { alpha:0, onComplete:closepopupHandler } );
			}
		}
		
		private function closepopupHandler():void 
		{
			spSubstrate.visible = false;
		}
	}

}