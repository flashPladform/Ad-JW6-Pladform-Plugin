package ru.pladform.plugin 
{
    import com.longtailvideo.jwplayer.events.PlayerStateEvent;
    import com.longtailvideo.jwplayer.player.IPlayer;
    import com.longtailvideo.jwplayer.player.PlayerState;
    import com.longtailvideo.jwplayer.plugins.PluginConfig;
    import ru.pladform.AdWrapper;
    import ru.pladform.event.AdEvent;
    
    /**
     * Взаимодействие с баннером на паузе (реклама показанная при постановке видео на паузу)
     * @author Alexander Semikolenov
     */
    public class WithPauseBanner extends WithPauseroll 
    {
        /**
         * Ссылка на рекламу
         */
        private var pausebannerTag  :String;
        
        public function WithPauseBanner() 
        {
            super();
        }
        
        // STATIC METHODS
        
        // ACCESSORS
        
        // PUBLIC METHODS
        /**
         * Инициализация плагина, API JWPlayer
         * @param player объект для управления плеером
         * @param config конфигурационные данные для инициализации плагина
         */
        override public function initPlugin(player:IPlayer, config:PluginConfig):void
        {
            super.initPlugin(player, config);
            pausebannerTag = config.pause_banner;
            player.addEventListener(PlayerStateEvent.JWPLAYER_PLAYER_STATE, playerStateHandler);
        }
        
        // PROTECTED METHODS
        
        // EVENT HANDLERS
        /**
         * Обработка событий баннера на паузе
         * @param e
         */
        private function adEventHandler(e:AdEvent):void 
        {
            if (e.type == AdEvent.AdStarted)
            {
                pauseVideo()
                canShowPauseroll = false;
            }
            else if (e.type == AdEvent.AllAdStopped)
            {
                player.unlock(this);
                //Подписываемся на информацию о том что рекламы нет
                removeAd(adEventHandler)
            }
        }
        
        private function playerStateHandler(e:PlayerStateEvent):void 
        {
            switch(e.newstate) 
            {
                case PlayerState.IDLE:
                {
                    //Инициализация баннера на живых потоках
                    if (!isLive) break;
                    if (e.oldstate == PlayerState.PLAYING)
                    {
                        if (!canShowPauseBanner || currentAdWrapper)
                        {
                            canShowPauseBanner = true;
                            return
                        }
                        canShowPauseroll = true;
                        
                        initPauseBanner();
                    }
                    break;
                }
                case PlayerState.PAUSED:
                {
                    //Инициализация баннера на обычных потоках
                    if (e.oldstate == PlayerState.PLAYING)
                    {
                        if (!canShowPauseBanner || currentAdWrapper)
                        {
                            canShowPauseBanner = true;
                            return
                        }
                        canShowPauseroll = true;
                        initPauseBanner();
                        
                    }
                    break;
                }
            }
        }
        
        // PRIVATE METHODS
        /**
         * Показ баннера на паузе
         */
        private function initPauseBanner():void 
        {
            if (!pausebannerTag)    return;
            if (!isModuleLoaded)    return;
            if (currentAdWrapper)   return;
            var adWrapper :AdWrapper= initAd(adEventHandler)
            adWrapper.viewInfo.roLinear.update(0, 0, playerSize.width, playerSize.height);
            adWrapper.load(pausebannerTag);
        }
    }

}