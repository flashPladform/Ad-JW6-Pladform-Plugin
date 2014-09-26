package ru.pladform.plugin 
{
	import com.longtailvideo.jwplayer.events.MediaEvent;
	import com.longtailvideo.jwplayer.events.PlayerStateEvent;
	import com.longtailvideo.jwplayer.player.IPlayer;
	import com.longtailvideo.jwplayer.player.PlayerState;
	import com.longtailvideo.jwplayer.plugins.IPlugin6;
	import com.longtailvideo.jwplayer.plugins.PluginConfig;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import flash.external.ExternalInterface;
	import flash.net.URLVariables;
	import flash.system.Security;
	import ru.pladform.AdType;
	import ru.pladform.event.AdEvent;
	import ru.pladform.event.AdLoaderEvent;
	import ru.pladform.adloader.AdLoader;
	import ru.pladform.adloader.event.ModuleLoadEvent;
	import ru.pladform.PladformAdWrapper;
	/**
	 * Базовый класс
	 * @author Alex Semikolenov (alex.semikolenov@gmail.com)
	 */
	public class BasePladformJWPlugin extends Sprite implements IPlugin6 
	{
		protected var player				:IPlayer;				//Интерфейс управления плееров согласно API JWPlayer
		protected var canShowPauseroll		:Boolean;				//флаг доступности паузролла
		protected var canShowPauseBanner	:Boolean;				//Флаг доступности вызова баннера на паузе
		protected var midrollTime			:Number;				//Время мидролла в секундах
		
		private var pl						:String;				//id плеера согласно API Pladform
		private var _isLive					:Boolean = true;		//воспроизводится ли потоковое вещание
		private var adWrapper				:PladformAdWrapper;		//обертка над рекламой для ее управления
		
		private var isAdView				:Boolean;				//Показывается ли реклама в данный момент
		
		public function BasePladformJWPlugin() 
		{
			Security.allowDomain("*");
			logRelease("Pladform JW Plugin:",CONFIG::timeStamp)
		}
		
		// STATIC METHODS
 		
		// ACCESSORS
		
		// PROTECTED METHODS
		/**
		 * Воспроизвести видео и разблокировать плеер
		 */
		protected function resumeVideo():void
		{
			try
			{
				if (player.state != PlayerState.PLAYING) 
				{
					player.play();
				}
			}
			catch (err:Error){log("!!!err",err)}
			//player.unlock(this);
		}
		/**
		 * Информирование о запуске воспроизведения рекламы
		 * @param	obj			- факитчески тут находится обертка рекламы, однако вижу примерение данного параметра с целью сравнения с обертки внутри класса, определяющего показ конкретного рекламного формата.
		 */
		protected function showAd(obj:Object):void 
		{
			
		}
		/**
		 * Инициализация рекламной обертки, с передачей типа рекламы
		 * @param	adWrapper	- обертка над рекламным модулем.
		 * @param	adType		- тип рекламы
		 */
		protected function initWrapper(adWrapper:PladformAdWrapper, adType:String):void
		{
			//Подписываемся на события рекламы
			log("initWrapper", AdType.asString(adType));
			if (!isAdView)
			{
				adWrapper.addEventListener(AdEvent.SHOW, adEventHandler);
				adWrapper.addEventListener(AdEvent.CLOSE, adEventHandler);
				adWrapper.addEventListener(AdEvent.COMPLETE, adEventHandler);
				adWrapper.addEventListener(AdEvent.CLICK, adEventHandler);
				adWrapper.addEventListener(AdEvent.EMPTY, adEventHandler);
				
				adWrapper.addEventListener(AdLoaderEvent.COMPLETE, adLoadEventHandler);
				adWrapper.addEventListener(AdLoaderEvent.ERROR, adLoadEventHandler);
				
				adWrapper.init(new URLVariables("pl=" + pl + "&type=" + adType))
			}
			else
			{
				adWrapper.dispatchEvent(new AdLoaderEvent(AdLoaderEvent.ERROR));
			}
		}
		/**
		 * Окончание рабоыт рекламы
		 * @param	dispatcher
		 * @param	isAfterVPAIDClick - Если реклама завершилась кликом, то необходимо ее завершить и контент оставить н паузе. такое поведение характерно в первую очередь для VPAID креативов
		 */
		protected function adComplete(dispatcher:EventDispatcher, isAfterVPAIDClick:Boolean):void 
		{
			dispatcher.removeEventListener(AdEvent.SHOW, adEventHandler);
			dispatcher.removeEventListener(AdEvent.CLOSE, adEventHandler);
			dispatcher.removeEventListener(AdEvent.COMPLETE, adEventHandler);
			dispatcher.removeEventListener(AdEvent.CLICK, adEventHandler);
			dispatcher.removeEventListener(AdEvent.EMPTY, adEventHandler);
			dispatcher.removeEventListener(AdLoaderEvent.COMPLETE, adLoadEventHandler);
			dispatcher.removeEventListener(AdLoaderEvent.ERROR, adLoadEventHandler);
			removeChild(dispatcher as DisplayObject)
		}
		/**
		 * В отладочном режиме выводим сообщение в консоль
		 * @param	...arg
		 */
		protected function log(...arg):void
		{
			CONFIG::debug
			{
				logRelease.apply(null, arg);
			}
		}
		protected function logRelease(...arg):void
		{
			var str:String = "[flash] "+arg.join(" ");
			try
			{
				ExternalInterface.call("console.log", str)
			}
			catch(err:Error){}
		}
		/**
		 * воспроизводится ли потоковое вещание
		 */
		protected function get isLive():Boolean 
		{
			return _isLive;
		}
		// PUBLIC METHODS
		
		/**
		 * Инициалиация согласно API JW
		 * @param	player
		 * @param	config
		 */
		public function initPlugin(player:IPlayer, config:PluginConfig):void
		{
			this.player = player;
			player.addEventListener(PlayerStateEvent.JWPLAYER_PLAYER_STATE, playerStateHandler);
			player.addEventListener(MediaEvent.JWPLAYER_MEDIA_TIME, liveDetectHandler);
			//player.pause();
			pl			= config.pl;
			midrollTime	= config.midroll_time ? config.midroll_time : 10;
			for (var val :String in player.config) 
			{
				log("player.config."+val, player.config[val])
			}
		}
		/**
		 * Ресайз согласно API JW, данный модуль всегда воспроизводится на весь экран управлять ресайзом нет необходимости
		 * @param	width
		 * @param	height
		 */
		public function resize(width:Number, height:Number):void
		{
			log("resize:", width, height/*, resObj*/)
			//resObj.update(0, 0, width, height);
		}
		/**
		 * Согласно API JW
		 */
		public function get id():String
		{
			return "pladform_jw";
		}
		/**
		 * Согласно API JW
		 */
		public function get target():String {
			return "6.0";
		}
		// EVENT HANDLERS
		
		protected function adLoadEventHandler(e:AdLoaderEvent):void 
		{
			log("??e.type =", e.type)
			if (e.type == AdLoaderEvent.ERROR)
			{
				isAdView = false;
				adComplete(EventDispatcher(e.currentTarget), false)
			}
		}
		
		protected function adEventHandler(e:AdEvent):void 
		{
			log("!!e.type =",e.type)
			if (
				e.type == AdEvent.CLOSE ||
				e.type == AdEvent.EMPTY
				)
			{
				isAdView = false;
				adComplete(EventDispatcher(e.currentTarget), false)
			}
			if (e.type == AdEvent.COMPLETE)
			{
				isAdView = false;
				adComplete(EventDispatcher(e.currentTarget),e.isAfterVPAIDClick)
			}
			if (e.type == AdEvent.SHOW)
			{
				isAdView = true;
				showAd(EventDispatcher(e.currentTarget))
			}
		}
		protected function lockHandler():void { trace("lock")}
		
		protected function playerStateHandler(e:PlayerStateEvent):void 
		{
			
		}
		// PRIVATE METHODS
		
		/**
		 * Определяем является ли видео лайв стримом. Возможно не лучшее решение, но лучшее что удалось найти.
		 * @param	e
		 */
		private function liveDetectHandler(e:MediaEvent):void 
		{
			log("IS NOT LIVE", e.position)
			if (e.position > 0)
			{
				player.removeEventListener(MediaEvent.JWPLAYER_MEDIA_TIME, liveDetectHandler);
				_isLive = false;
			}
		}
		
	}

}