package ru.pladform.plugin 
{
	import com.longtailvideo.jwplayer.events.PlayerStateEvent;
	import com.longtailvideo.jwplayer.player.PlayerState;
	import flash.events.EventDispatcher;
	import ru.pladform.adloader.AdLoader;
	import ru.pladform.adloader.event.ModuleLoadEvent;
	import ru.pladform.AdType;
	import ru.pladform.event.AdEvent;
	import ru.pladform.PladformAdWrapper;
	/**
	 * ...
	 * @author Alexander Semikolenov (alex.semikolenov@gmail.com)
	 */
	public class WithPauseBanner extends WithPauseroll
	{
		private var adWrapperPauseBanner:PladformAdWrapper;
		
		public function WithPauseBanner() 
		{
			
		}
		
		// STATIC METHODS
		
		// ACCESSORS
		
		// PUBLIC METHODS
		override protected function playerStateHandler(event:PlayerStateEvent):void 
		{
			super.playerStateHandler(event);
			switch(event.newstate) 
			{
				case PlayerState.IDLE:
				{
					//Инициализация баннера на живых потоках
					if (!isLive) break;
					if (event.oldstate == PlayerState.PLAYING)
					{
						if (!canShowPauseBanner || adWrapperPauseBanner)
						{
							canShowPauseBanner = true;
							return
						}
						canShowPauseroll = true;
						
						initPauseBuner();
					}
					break;
				}
				case PlayerState.PAUSED:
				{
					//Инициализация баннера на обычных потоках
					if (event.oldstate == PlayerState.PLAYING)
					{
						if (!canShowPauseBanner || adWrapperPauseBanner)
						{
							canShowPauseBanner = true;
							return
						}
						canShowPauseroll = true;
						initPauseBuner();
						
					}
					break;
				}
			}
		}
		// PROTECTED METHODS
		override protected function adComplete(dispatcher:EventDispatcher, isAfterVPAIDClick:Boolean):void 
		{
			super.adComplete(dispatcher, isAfterVPAIDClick);
			if (dispatcher == adWrapperPauseBanner)
			{
				player.unlock(this);
				//Подписываемся на информацию о том что рекламы нет
				adWrapperPauseBanner.removeEventListener(AdEvent.EMPTY,  emptyHandler);
				adWrapperPauseBanner = null;
			}
			
		}
		// EVENT HANDLERS
		
		private function emptyHandler(e:AdEvent):void 
		{
			//Т.к. этот баннер на паузе не воспроизвелся то можно показать паузролл
			canShowPauseroll = true;
		}
		
		private function moduleLoadHandler(e:ModuleLoadEvent):void 
		{	
			if (e.type == ModuleLoadEvent.LOAD_COMPLETE)
			{
				adWrapperPauseBanner = e.adWrapper;
				adWrapperPauseBanner.addEventListener(AdEvent.EMPTY,  emptyHandler);
				initWrapper(adWrapperPauseBanner, AdType.PAUSE_BANNER)
				addChild(adWrapperPauseBanner);
				canShowPauseroll = false;
				player.lock(this, lockHandler);
			}
			else
			{
				//Паузролл можно показать
				canShowPauseroll = true;
			}
		}
		
		// PRIVATE METHODS
		
		private function initPauseBuner():void 
		{
			//Готовимся показать баннер на паузе
			var loader:AdLoader = new AdLoader();
			loader.addEventListener(ModuleLoadEvent.LOAD_COMPLETE, moduleLoadHandler);
			loader.addEventListener(ModuleLoadEvent.LOAD_ERROR, moduleLoadHandler);
			loader.load();
		}
		
	}

}