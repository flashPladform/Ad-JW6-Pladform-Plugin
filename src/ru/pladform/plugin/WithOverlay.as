package ru.pladform.plugin 
{
    import com.longtailvideo.jwplayer.events.MediaEvent;
    import com.longtailvideo.jwplayer.player.IPlayer;
    import com.longtailvideo.jwplayer.plugins.PluginConfig;
    import ru.ngl.utils.Console;
    import ru.pladform.AdWrapper;
    import ru.pladform.event.AdEvent;

    /**
     * Взаимодействие с оверлеем
     * @author Alexander Semikolenov
     */
    public class WithOverlay extends WithMidroll
    {
        /**
         * Время показа оверлей
         */
        private var ovelayTime          :Number;
        /**
         * Ссылка на рекламу
         */
        private var ovelayTag           :String;
        /**
         * Флаг показа рекламы
         */
        protected var isOverlayShowed   :Boolean;
        /**
         * Нужно ли показывать оверлей
         */
        protected var baseOverlayState  :Boolean;
        
        public function WithOverlay() 
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
            ovelayTag           = config.overlay;
            //Получаем время показа оверлея из конфига
            ovelayTime          = config.overlay_time;
            //если время не нулевое, считаем что рекламу надо показывать
            baseOverlayState    = !(ovelayTime && ovelayTime > 0);
            //Выставляем флаг показа рекламы в зависимости от того надо ли ее показывать
            isOverlayShowed     = baseOverlayState
            player.addEventListener(MediaEvent.JWPLAYER_MEDIA_TIME, mediaTimeHandler);
        }
        
        // PROTECTED METHODS
        
        // EVENT HANDLERS
        /**
         * Обработка событий оверлея
         * @param e
         */
        private function adEventHandler(e:AdEvent):void 
        {
            if (e.type == AdEvent.AllAdStopped)
            {
                player.unlock(this)
                removeAd(adEventHandler);
            }
        }
        /**
         * Следим за прогрессом воспроизведения для определения времени показа оверлея
         * @param e
         */
        private function mediaTimeHandler(e:MediaEvent):void 
        {
            if (!isOverlayShowed && Number(e.position) >= ovelayTime)
            {
                if (!ovelayTag)         return;
                if (!isModuleLoaded)    return;
                if (currentAdWrapper)   return;
                isOverlayShowed             = true;
                //Готовимся показывать оверлей
                Console.log2("OVERLAY")
                var adWrapper   :AdWrapper  = initAd(adEventHandler);
                adWrapper.viewInfo.roLinear.update(0, 0, playerSize.width, playerSize.height-50);
                adWrapper.load(ovelayTag);
            }
        }
        
        // PRIVATE METHODS
    }

}