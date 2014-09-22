package ru.pladform.plugin 
{
	import com.longtailvideo.jwplayer.events.PlayerStateEvent;
	import com.longtailvideo.jwplayer.player.PlayerState;
	import flash.events.EventDispatcher;
	import ru.pladform.adloader.AdLoader;
	import ru.pladform.adloader.event.ModuleLoadEvent;
	import ru.pladform.AdType;
	import ru.pladform.PladformAdWrapper;
	/**
	 * ...
	 * @author Alexander Semikolenov (alex.semikolenov@gmail.com)
	 */
	public class WithPauseroll extends WithPostroll
	{
		private var isAfterBuffer		:Boolean;
		private var adWrapperPauseroll	:PladformAdWrapper;
		
		public function WithPauseroll() 
		{
			
		}
		
		// STATIC METHODS
		
		// ACCESSORS
		
		// PUBLIC METHODS
		
		// PROTECTED METHODS
		override protected function playerStateHandler(event:PlayerStateEvent):void 
		{
			super.playerStateHandler(event);
			switch(event.newstate) 
			{
				case PlayerState.PLAYING:
				{
					//Инициализация баннера на живых потоках
					if ((event.oldstate == PlayerState.IDLE && isNoFirstPlay) || event.oldstate == PlayerState.PAUSED || isAfterBuffer)
					{
						if (!canShowPauseroll || adWrapperPauseroll)
						{
							return
						}
						canShowPauseBanner = false;
						initPauseroll()
					}
					break;
				}
				default:
				{
					//Инициализация баннера на обычных потоках
					if (event.newstate == PlayerState.BUFFERING && (event.oldstate == PlayerState.IDLE||event.oldstate == PlayerState.PAUSED))
					{
						isAfterBuffer = true;
					}
					else
					{
						isAfterBuffer = false;
					}
				}
			}
		}
		
		override protected function adComplete(dispatcher:EventDispatcher, isAfterVPAIDClick:Boolean):void 
		{
			super.adComplete(dispatcher, isAfterVPAIDClick);
			if (dispatcher == adWrapperPauseroll)
			{
				player.unlock(this);
				
				canShowPauseBanner	= true;
				canShowPauseroll	= false;
				
				if (!isAfterVPAIDClick)
				{
					resumeVideo();
				}
				
				
				adWrapperPauseroll = null
			}
		}
		
		override protected function showAd(obj:Object):void 
		{
			super.showAd(obj);
			if (obj == adWrapperPauseroll)
			{
				player.unlock(this);
				log("PAUSE PAUSE")
				player.pause();
				player.lock(this, lockHandler);
			}
			
		}
		// EVENT HANDLERS
		
		private function moduleLoadHandler(e:ModuleLoadEvent):void 
		{
			if (e.type == ModuleLoadEvent.LOAD_COMPLETE)
			{
				adWrapperPauseroll= e.adWrapper;
				initWrapper(adWrapperPauseroll, AdType.PAUSEROLL)
				addChild(adWrapperPauseroll);
				
				player.lock(this, lockHandler);
			}
		}
		
		// PRIVATE METHODS
		
		private function initPauseroll():void 
		{
			var loader:AdLoader = new AdLoader();
			loader.addEventListener(ModuleLoadEvent.LOAD_COMPLETE, moduleLoadHandler);
			loader.addEventListener(ModuleLoadEvent.LOAD_ERROR, moduleLoadHandler);
			loader.load();
		}
		
	}

}