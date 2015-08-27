package ru.pladform.plugin 
{
    import com.longtailvideo.jwplayer.events.MediaEvent;
    import com.longtailvideo.jwplayer.player.IPlayer;
    import com.longtailvideo.jwplayer.plugins.PluginConfig;
    import flash.events.Event;
    import ru.ngl.utils.Console;
    import ru.pladform.AdWrapper;
    import ru.pladform.event.AdEvent;

    /**
     * Взаимодействие с построллом
     * @author Alexander Semikolenov
     */
    public class WithPostroll extends WithOverlay
    {
        /**
         * Ссылка на рекламу
         */
        private var postrollTag:String;
        
        public function WithPostroll() 
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
            postrollTag = config.postroll;
            //Подписываемся на окончание видео
            player.addEventListener(MediaEvent.JWPLAYER_MEDIA_COMPLETE, mediaCompleteHandler);
        }
        // PROTECTED METHODS
        
        // EVENT HANDLERS
        /**
         * Обработка событий постролла
         * @param e
         */
        private function adEventHandler(e:AdEvent):void 
        {
            if (e.type == AdEvent.AdStarted)
            {
                player.lock(this, lockHandler);
            }
            else if (e.type == AdEvent.AllAdStopped)
            {
                //Сбрасываем флаги для одноразовых реклам
                postrollComplete()
                removeAd(adEventHandler)
            }
        }
        /**
         * Завершение показа видео, подготовка к показу постролла
         * @param e
         */
        private function mediaCompleteHandler(e:MediaEvent):void 
        {
            //Готовимся показать постролл
            if (postrollTag)
            {
                if (!isModuleLoaded)    return;
                /**
                 * Удаляем текущую рекламу, если она есть
                 */
                Console.log2("POSTROLL")
                removeAd(null)
                var adWrapper   :AdWrapper  = initAd(adEventHandler);
                adWrapper.viewInfo.roLinear.update(0, 0, playerSize.width, playerSize.height);
                addChild(adWrapper);
            }
            else
            {
                postrollComplete()
            }
        }
        
        // PRIVATE METHODS
        /**
         * Сброс настроек рекламы
         */
        private function postrollComplete():void
        {
            isNoFirstPlay   = false;
            isMidrolShowed  = baseMidrollState;
            isOverlayShowed = baseOverlayState;
            player.unlock(this);
        }
        
    }

}