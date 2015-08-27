package ru.pladform.plugin 
{
    import com.longtailvideo.jwplayer.events.MediaEvent;
    import com.longtailvideo.jwplayer.player.IPlayer;
    import com.longtailvideo.jwplayer.plugins.PluginConfig;
    import ru.ngl.utils.Console;
    import ru.pladform.plugin.WithPreroll;
    import ru.pladform.AdWrapper;
    import ru.pladform.event.AdEvent;
    

    /**
     * Взаимодействие с мидроллом
     * @author Alexander Semikolenov
     */
    public class WithMidroll extends WithPreroll 
    {
        /**
         * Время показа мидролла
         */
        private var midrollTime         :Number;
        /**
         * Ссылка на рекламу
         */
        private var midrollTag          :String;
        /**
         * Флаг показа рекламы
         */
        protected var isMidrolShowed    :Boolean;
        /**
         * Нужно ли показывать мидролл
         */
        protected var baseMidrollState  :Boolean;
        
        public function WithMidroll() 
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
            //Получаем ссылку на рекламу из конфига
            midrollTag          = config.midroll;
            //Получаем время показа мидролла из конфига
            midrollTime         = config.midroll_time;
            //если время не нулевое, считаем что рекламу надо показывать
            baseMidrollState    = !(midrollTime && midrollTime > 0);
            //Выставляем флаг показа рекламы в зависимости от того надо ли ее показывать
            isMidrolShowed      = baseMidrollState
            player.addEventListener(MediaEvent.JWPLAYER_MEDIA_TIME, mediaTimeHandler);
        }
        
        // PROTECTED METHODS
        
        // EVENT HANDLERS
        /**
         * Обработка событий мидролла
         * @param e
         */
        private function adEventHandler(e:AdEvent):void 
        {
            if (e.type == AdEvent.AdStarted)
            {
                //ставим контент на паузу, при этом выствляем ограничивающие флаги
                canShowPauseBanner  = false;
                pauseVideo();
                canShowPauseroll    = true;
            }
            else if (e.type == AdEvent.AllAdStopped)
            {
                player.unlock(this);
                //Запускаем видео, если есть необходимость, делаем возвожным запуск баннера на паузе
                canShowPauseroll    = false;
                canShowPauseBanner  = true;
                if (!isNeedPutVideoOnPause)
                {
                    resumeVideo();
                }
                removeAd(adEventHandler)
            }
        }
        /**
         * Следим за прогрессом воспроизведения для определения времени показа мидролла
         * @param e
         */
        private function mediaTimeHandler(e:MediaEvent):void 
        {
            
            if (!isMidrolShowed && Number(e.position) >= midrollTime)
            {
                if (!midrollTag)        return;
                if (!isModuleLoaded)    return;
                if (currentAdWrapper)   return;
                Console.log2("MIDROLL -",currentAdWrapper,"-")
                isMidrolShowed              = true;
                //Готовимся показывать мидролл
                var adWrapper   :AdWrapper  = initAd(adEventHandler);
                adWrapper.viewInfo.roLinear.update(0, 0, playerSize.width, playerSize.height);
                adWrapper.load(midrollTag);
            }
        }
        
        // PRIVATE METHODS
        
    }

}