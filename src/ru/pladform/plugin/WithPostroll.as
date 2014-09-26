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
	public class WithPostroll extends WithMidroll
	{
		private var adWrapperPostroll:PladformAdWrapper;
		
		public function WithPostroll() 
		{
		}
		
		// STATIC METHODS
		
		// ACCESSORS
		
		// PUBLIC METHODS
		override public function initPlugin(player:IPlayer, config:PluginConfig):void
		{
			super.initPlugin(player, config);
			//Подписываемся на окончание видео
			player.addEventListener(MediaEvent.JWPLAYER_MEDIA_COMPLETE, mediaCompleteHandler);
		}
		// PROTECTED METHODS
		override protected function adComplete(dispatcher:EventDispatcher, isAfterVPAIDClick:Boolean):void 
		{
			super.adComplete(dispatcher, isAfterVPAIDClick);
			if (dispatcher == adWrapperPostroll)
			{
				postrollComplete()
				adWrapperPostroll = null;
			}
		}
		// EVENT HANDLERS
		
		private function moduleLoadHandler(e:ModuleLoadEvent):void 
		{
			if (e.type == ModuleLoadEvent.LOAD_COMPLETE)
			{
				adWrapperPostroll= e.adWrapper;
				initWrapper(adWrapperPostroll, AdType.POSTROLL)
				addChild(adWrapperPostroll);
				player.lock(this, lockHandler);
			}
			else
			{
				postrollComplete()
			}
		}
		
		private function mediaCompleteHandler(e:MediaEvent):void 
		{
			//Готовимся показать постролл
			var loader:AdLoader = new AdLoader();
			loader.addEventListener(ModuleLoadEvent.LOAD_COMPLETE, moduleLoadHandler);
			loader.addEventListener(ModuleLoadEvent.LOAD_ERROR, moduleLoadHandler);
			loader.load();
		}
		
		// PRIVATE METHODS
		private function postrollComplete():void 
		{
			//Сбрасываем флаги для одноразовых реклам
			isNoFirstPlay	= false;
			isMidrolShowed	= baseMidrollState;
			player.unlock(this);
		}
	}

}