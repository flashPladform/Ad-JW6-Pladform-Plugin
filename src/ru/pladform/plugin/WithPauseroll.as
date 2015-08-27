package ru.pladform.plugin 
{
    import com.longtailvideo.jwplayer.events.PlayerStateEvent;
    import com.longtailvideo.jwplayer.player.IPlayer;
    import com.longtailvideo.jwplayer.player.PlayerState;
    import com.longtailvideo.jwplayer.plugins.PluginConfig;
    import ru.pladform.AdWrapper;
    import ru.pladform.event.AdEvent;

    /**
     * Взаимодействие с паузроллом (реклама показанная перед возобновлением воспроизведения после паузы)
     * @author Alexander Semikolenov
     */
    public class WithPauseroll extends WithPostroll
    {
        /**
         * Флаг после буфферизации
         */
        private var isAfterBuffer       :Boolean;
        /**
         * Ссылка на рекламу
         */
        private var pauserollTag        :String;
        /**
         * Флаг показа паузролла
         */
        private var isAfterShow         :Boolean;
        
        public function WithPauseroll() 
        {
            
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
            pauserollTag    = config.pauseroll;
            player.addEventListener(PlayerStateEvent.JWPLAYER_PLAYER_STATE, playerStateHandler);
        }
        
        // PROTECTED METHODS
        
        // EVENT HANDLERS
        /**
         * Обработка событий паузролла
         * @param e
         */
        private function adEventHandler(e:AdEvent):void 
        {
            if (e.type == AdEvent.AdStarted)
            {
                pauseVideo();
                isAfterShow = true;
            }
            else if (e.type == AdEvent.AllAdStopped)
            {
                if (isAfterShow)
                {
                    player.unlock(this);
                    if (!isNeedPutVideoOnPause)
                    {
                        resumeVideo();
                    }
                }
                canShowPauseBanner  = true;
                canShowPauseroll    = false;
                removeAd(adEventHandler);
            }
        }
        /**
         * Обработка событий плеера для определения момента показа паузролла
         * @param e
         */
        private function playerStateHandler(e:PlayerStateEvent):void 
        {
            switch(e.newstate) 
            {
                case PlayerState.PLAYING:
                {
                    //Инициализация баннера на живых потоках
                    if ((e.oldstate == PlayerState.IDLE && isNoFirstPlay) || e.oldstate == PlayerState.PAUSED || isAfterBuffer)
                    {
                        if (!canShowPauseroll || currentAdWrapper)
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
                    if (e.newstate == PlayerState.BUFFERING && (e.oldstate == PlayerState.IDLE||e.oldstate == PlayerState.PAUSED))
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
        
        // PRIVATE METHODS
        /**
         * Показ паузролла
         */
        private function initPauseroll():void 
        {
            if (!pauserollTag)      return;
            if (!isModuleLoaded)    return;
            if (currentAdWrapper)   return;
            canShowPauseBanner          = false;
            var adWrapper   :AdWrapper  = initAd(adEventHandler)
            adWrapper.viewInfo.roLinear.update(0, 0, playerSize.width, playerSize.height);
            adWrapper.load(pauserollTag);
        }
    }

}