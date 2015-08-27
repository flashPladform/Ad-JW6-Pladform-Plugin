package ru.pladform.plugin 
{
    import com.longtailvideo.jwplayer.events.MediaEvent;
    import com.longtailvideo.jwplayer.player.IPlayer;
    import com.longtailvideo.jwplayer.plugins.PluginConfig;
    import flash.events.TimerEvent;
    import flash.utils.Timer;
    import ru.ngl.utils.Console;
    import ru.pladform.AdWrapper;
    import ru.pladform.event.AdEvent;

    /**
     * Взаимодействие с прероллом
     * @author Alexander Semikolenov
     */
    public class WithPreroll extends BasePladformAd
    {
        /**
         * Ссылка на рекламу
         */
        private var prerollTag          :String;
        /**
         * Флаг того изменения прогресса воспроизведения для отслеживания преролла
         */
        protected var isNoFirstPlay     :Boolean
        
        public function WithPreroll() 
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
            //Получаем ссылку на рекламу из конфига
            prerollTag  = config.preroll
            //Следим за прогрессом воспроизведения для определения времени для преролла
            player.addEventListener(MediaEvent.JWPLAYER_MEDIA_TIME, prerollDetectHandler);
        }
        
        // PROTECTED METHODS
        
        // EVENT HANDLERS
        /**
         * Обработка событий преролла
         * @param e
         */
        private function adEventHandler(e:AdEvent):void 
        {
            if (e.type == AdEvent.AdStarted)
            {
                //ставим контент на паузу, при этом выствляем ограничивающие флаги
                canShowPauseBanner  = false;
                pauseVideo();
                canShowPauseroll    = false;
            }
            else if (e.type == AdEvent.AllAdStopped)
            {
                player.unlock(this);
                //Запускаем видео, если есть необходимость, делаем возвожным запуск баннера на паузе
                canShowPauseBanner  = true;
                if (!isNeedPutVideoOnPause)
                {
                    resumeVideo();
                }
                removeAd(adEventHandler);
            }
        }
        /**
         * Следим за прогрессом воспроизведения для определения времени показа преролла
         * @param e
         */
        private function prerollDetectHandler(e:MediaEvent):void 
        {
            if (isNoFirstPlay)      return;
            if (!isModuleLoaded)    return;
            if (currentAdWrapper)   return;
            if (!prerollTag)
            {
                //Если преролл не передан, делаем возможным запуск реклам связанных с паузой
                canShowPauseBanner  = true;
                canShowPauseroll    = true;
                return;
            }
            isNoFirstPlay           = true;
            canShowPauseBanner      = false;
            canShowPauseroll        = false;
            //Готовимся показывать преролл
            Console.log2("PREROLL")
            var adWrapper   :AdWrapper  = initAd(adEventHandler);
            adWrapper.viewInfo.roLinear.update(0, 0, playerSize.width, playerSize.height);
            adWrapper.load(prerollTag)
        }
        
        // PRIVATE METHODS
        
    }

}