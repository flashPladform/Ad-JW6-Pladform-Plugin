package ru.pladform.plugin 
{
	import com.longtailvideo.jwplayer.events.MediaEvent;
	import com.longtailvideo.jwplayer.player.IPlayer;
	import com.longtailvideo.jwplayer.plugins.PluginConfig;
	import flash.events.EventDispatcher;
	import ru.pladform.adloader.AdLoader;
	import ru.pladform.adloader.event.ModuleLoadEvent;
	import ru.pladform.AdType;
	import ru.pladform.PladformAdWrapper;
	/**
	 * ...
	 * @author Alexander Semikolenov (alex.semikolenov@gmail.com)
	 */
	public class WithMidroll extends WithPreroll
	{
		protected var isMidrolShowed	:Boolean; // онформация о том показан ли мидролл
		private var adWrapperMidroll	:PladformAdWrapper;
		
		public function WithMidroll() 
		{
			
		}
		
		// STATIC METHODS
		
		// ACCESSORS
		
		// PUBLIC METHODS
		override public function initPlugin(player:IPlayer, config:PluginConfig):void
		{
			super.initPlugin(player, config)
			
			player.addEventListener(MediaEvent.JWPLAYER_MEDIA_TIME, mediaTimeHandler);
			
		}
		// PROTECTED METHODS
		override protected function showAd(obj:Object):void 
		{
			super.showAd(obj);
			if (obj == adWrapperMidroll)
			{
				canShowPauseBanner	= false;
				log("MID PAUSE")
				player.pause();
				player.lock(this, lockHandler);
				canShowPauseroll	= true;
			}
		}
		
		override protected function adComplete(dispatcher:EventDispatcher, isAfterVPAIDClick:Boolean):void 
		{
			super.adComplete(dispatcher, isAfterVPAIDClick);
			if (dispatcher == adWrapperMidroll)
			{
				player.unlock(this);
				canShowPauseroll	= false;
				canShowPauseBanner	= true;
				if (!isAfterVPAIDClick)
				{
					resumeVideo();
				}
				adWrapperMidroll = null;
			}
		}
		// EVENT HANDLERS
		
		private function moduleLoadHandler(e:ModuleLoadEvent):void 
		{
			if (e.type == ModuleLoadEvent.LOAD_COMPLETE)
			{
				adWrapperMidroll= e.adWrapper;
				initWrapper(adWrapperMidroll, AdType.MIDLE_ROLL)
				addChild(adWrapperMidroll);
			}
		}
		
		private function mediaTimeHandler(e:MediaEvent):void 
		{
			if (!isMidrolShowed && Number(e.position) >= 5)
			{
				isMidrolShowed = true;
				//Готовимся показывать мидролл
				var loader:AdLoader = new AdLoader();
				loader.addEventListener(ModuleLoadEvent.LOAD_COMPLETE, moduleLoadHandler);
				loader.addEventListener(ModuleLoadEvent.LOAD_ERROR, moduleLoadHandler);
				loader.load();
			}
		}
		
		// PRIVATE METHODS
	}

}