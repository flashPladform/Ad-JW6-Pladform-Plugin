package ru.pladform.plugin 
{
	import com.longtailvideo.jwplayer.events.MediaEvent;
	import com.longtailvideo.jwplayer.events.PlayerStateEvent;
	import com.longtailvideo.jwplayer.player.IPlayer;
	import com.longtailvideo.jwplayer.player.PlayerState;
	import com.longtailvideo.jwplayer.plugins.PluginConfig;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import ru.pladform.AdType;
	import ru.pladform.event.AdEvent;
	import ru.pladform.event.AdLoaderEvent;
	import ru.pladform.adloader.AdLoader;
	import ru.pladform.adloader.event.ModuleLoadEvent;
	import ru.pladform.PladformAdWrapper;
	/**
	 * ...
	 * @author Alex Semikolenov (alex.semikolenov@gmail.com)
	 */
	public class WithPreroll extends BasePladformJWPlugin
	{
		private var adWrapperPreroll	:PladformAdWrapper;	//Реклама
		protected var isNoFirstPlay		:Boolean;			//Флаг первого запуска воспроизведения для определения преорлла
		
		public function WithPreroll() 
		{
			
		}
		
		// STATIC METHODS
 		
		// ACCESSORS
		
		// PROTECTED METHODS
		
		override public function initPlugin(player:IPlayer, config:PluginConfig):void
		{
			super.initPlugin(player, config)
			player.addEventListener(MediaEvent.JWPLAYER_MEDIA_TIME, prerollDetectHandler);
		
		}
		
		/*override protected function playerStateHandler(event:PlayerStateEvent):void 
		{
			super.playerStateHandler(event);
			switch(event.newstate) 
			{
				case PlayerState.PLAYING:
				{
					//Только при первом запуске видео (PlayerState.PLAYING) преролл является прероллом
					if (isNoFirstPlay) return;
					isNoFirstPlay 		= true;
					//player.lock();
					player.pause();
					canShowPauseBanner	= false;
					canShowPauseroll	= false;
					//Готовимся показывать преролл
					var loader:AdLoader = new AdLoader();
					loader.addEventListener(ModuleLoadEvent.LOAD_COMPLETE, moduleLoadHandler);
					loader.addEventListener(ModuleLoadEvent.LOAD_ERROR, moduleLoadHandler);
					loader.load();
				}
			}
		}*/
		
		override protected function adComplete(dispatcher:EventDispatcher, isAfterVPAIDClick:Boolean):void 
		{
			super.adComplete(dispatcher, isAfterVPAIDClick);
			
			
			if (dispatcher == adWrapperPreroll)
			{
				player.unlock(this);
				
				canShowPauseBanner	= true;
				//Запускаем видео через короткий промежуток времени
				if (!isAfterVPAIDClick)
				{
					/*var time:uint = 200;
					var timer:Timer = new Timer(time, 1);
					timer.addEventListener(TimerEvent.TIMER, playerPlay);
					timer.start()*/
					playAfterPreroll();
				}
				adWrapperPreroll = null;
			}
		}
		override protected function showAd(obj:Object):void 
		{
			super.showAd(obj);
			if (obj == adWrapperPreroll)
			{
				//При старте преролла ставим ролик на паузу
				canShowPauseBanner	= false;
				player.pause();
				player.lock(this, lockHandler);
				canShowPauseroll = false;
			}
		}
		// PUBLIC METHODS
		
		// EVENT HANDLERS
		
		private function prerollDetectHandler(e:MediaEvent):void 
		{
			//Только при первом запуске видео (PlayerState.PLAYING) преролл является прероллом
			//if e.position
			if (isNoFirstPlay) return;
			isNoFirstPlay 		= true;
			player.pause();
			//player.lock(this,lockHandler)
			canShowPauseBanner	= false;
			canShowPauseroll	= false;
			//Готовимся показывать преролл
			var loader:AdLoader = new AdLoader();
			loader.addEventListener(ModuleLoadEvent.LOAD_COMPLETE, moduleLoadHandler);
			loader.addEventListener(ModuleLoadEvent.LOAD_ERROR, moduleLoadHandler);
			loader.load();
		}
		
		private function playerPlay(e:TimerEvent):void
		{
			resumeVideo();
		}
		
		private function moduleLoadHandler(e:ModuleLoadEvent):void 
		{
			canShowPauseBanner = true;
			if (e.type == ModuleLoadEvent.LOAD_COMPLETE)
			{
				adWrapperPreroll= e.adWrapper;
				initWrapper(adWrapperPreroll, AdType.PREROLL)
				addChild(adWrapperPreroll);
			}
			else
			{
				//resumeVideo();
				playAfterPreroll();
			}
		}
		
		// PRIVATE METHODS
		private function playAfterPreroll():void
		{
			var time:uint = 200;
			var timer:Timer = new Timer(time, 1);
			timer.addEventListener(TimerEvent.TIMER, playerPlay);
			timer.start()
		}
	}

}