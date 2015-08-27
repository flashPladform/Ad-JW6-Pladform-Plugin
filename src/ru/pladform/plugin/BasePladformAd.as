package ru.pladform.plugin 
{
    import com.longtailvideo.jwplayer.player.IPlayer;
    import com.longtailvideo.jwplayer.player.PlayerState;
    import com.longtailvideo.jwplayer.plugins.PluginConfig;
    import ru.ngl.utils.Console;
    import ru.pladform.AdCreator;
    import ru.pladform.AdWrapper;
    import ru.pladform.event.AdEvent;
    import ru.pladform.event.PladformAdModuleEvent;
    
    /**
     * Базовый класс управления рекламой
     * @author Alexander Semikolenov
     */
    public class BasePladformAd extends BasePladformJWPlugin 
    {
        /**
         * Объект создающий рекламурекламный модуль Pladform
         */
        protected var adModuleCreator           :AdCreator;
        /**
         * Флаг загрузки рекламного модуля
         */
        protected var isModuleLoaded            :Boolean;
        /**
         * флаг доступности паузролла
         */
        protected var canShowPauseroll          :Boolean;
        /**
         * Флаг доступности вызова баннера на паузе
         */
        protected var canShowPauseBanner        :Boolean;
        /**
         * Текущая реклама, если реклама уже запущена, то новая не может быть создана
         */
        protected var currentAdWrapper          :AdWrapper;
        /**
         * Флаг, означающий, что реклама не встала на паузу после клика по ней
         */
        protected var isNeedPutVideoOnPause   :Boolean;
        
        public function BasePladformAd() 
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
            /**
             * Инициация рекламного модуля Pladform
             */
            adModuleCreator = new AdCreator();
            adModuleCreator.addEventListener(PladformAdModuleEvent.READY, pladformAdModuleHandler);
            adModuleCreator.addEventListener(PladformAdModuleEvent.ERROR, pladformAdModuleHandler);
            adModuleCreator.load();
        }
        // PROTECTED METHODS
        /**
         * Инициализация рекламы, создаем объект управления рекламой и подписываемся на его события, так же подписываем на события переданную функцию от дочернего класса, который реклизует непосредственное взаимодействие видео, рекламным форматом и взаимоотошения между рекламными форматами.
         * @param adHandler обработчик рекламы
         * @return объект управления рекламой
         */
        protected function initAd(adHandler:Function):AdWrapper
        {
            //Реклама на данный момент не должна показываться, если попытаться ее показать, вызываем исключение
            Console.log2("currentAdWrapper =",currentAdWrapper)
            if (currentAdWrapper)
            {
                throw new Error("AdWrapper must be only one!")
            }
            //Создаем объект управления рекламой
            isNeedPutVideoOnPause             = false;
            currentAdWrapper                    = adModuleCreator.create();
            //Подписыываемся на все рекламные события
            var vecEvent    :Vector.<String>    = AdEvent.allEvent;
            var length      :uint               = vecEvent.length;
            for (var i:int = 0; i < length; i++) 
            {
                currentAdWrapper.addEventListener(vecEvent[i], baseAdHandler);
                currentAdWrapper.addEventListener(vecEvent[i], adHandler);
            }
            //Добавляем объект управления рекламой на на сцену
            addChild(currentAdWrapper);
            return currentAdWrapper
        }
        
        /**
         * Описываемся от всех событий рекламы и уничтожаем текущую воспроизводящуюся рекламу, если таковая есть
         * @param adHandler
         */
        protected function removeAd(adHandler:Function):void
        {
            Console.log2("-=REMOVE_AD=-")
            if (currentAdWrapper)
            {
                var vecEvent    :Vector.<String>    = AdEvent.allEvent;
                var length      :uint               = vecEvent.length;
                for (var i:int = 0; i < length; i++) 
                {
                    currentAdWrapper.removeEventListener(vecEvent[i], baseAdHandler);
                    if (adHandler!=null)
                    {
                        currentAdWrapper.removeEventListener(vecEvent[i], adHandler);
                    }
                }
                removeChild(currentAdWrapper);
                currentAdWrapper = null
            }
        }
        
        /**
         * Переопределяем изменение размера плеера API JWPlayer, на случай, если реклама показывается
         * @param width ширина
         * @param height высота
         */
        override public function resize(width:Number, height:Number):void 
        {
            super.resize(width, height);
            if (currentAdWrapper)
            {
                //Для линейной рекламы показываем показываем рекламный контент на всей области отображения, 
                //для нелинейной на 50px выше, чтобы не перекрывать UI плеера
                if (currentAdWrapper.adLinear)
                {
                    currentAdWrapper.viewInfo.roLinear.update(0, 0, width, height);
                }
                else
                {
                    currentAdWrapper.viewInfo.roLinear.update(0, 0, width, height - 50);
                }
            }
        }
        // EVENT HANDLERS
        /**
         * Базовый обработкичики событий рекламы, логика которая действует для всех типов рекламы
         * @param e
         */
        private function baseAdHandler(e:AdEvent):void 
        {
            var needPauseChange :Boolean
            var needPause       :Boolean
            if (e.type == AdEvent.AdClickThru)
            {
                //При клике по рекламы нужно выйти из состояния фулскрина, если в нем находились, а так же поставить видео на паузу
                pauseVideo();
                player.fullscreen(false);
                isNeedPutVideoOnPause = true;
            }
            else if(e.type == AdEvent.AdPaused)
            {
                //Реклама встала на паузу не важно из-зи клика или нет
                isNeedPutVideoOnPause = false;
            }
            else if (e.type == AdEvent.AdLinearChange)
            {
                //Смена линейности рекламы. Проверяем, если реклама линейна, то надо ставить ее на паузу.
                needPauseChange = true
                needPause       = currentAdWrapper.adLinear;
                resize(playerSize.width, playerSize.height);
            }
            else if (e.type == AdEvent.AdExpandedChange)
            {
                //Смена "развернутости" рекламы. Проверяем, если реклама "развернута", то надо ставить ее на паузу.
                needPauseChange = true
                needPause       = currentAdWrapper.adExpanded;
            }
            if (needPauseChange)
            {
                //Если надо ставить на паузу, ставим, если не надо, снимаем с паузы
                if (needPause)
                {
                    pauseVideo()
                }
                else
                {
                    resumeVideo()
                }
            }
        }
        /**
         * События определяющие готовносит рекламного модуля Pladfocm к работе
         * @param e
         */
        private function pladformAdModuleHandler(e:PladformAdModuleEvent):void 
        {
            if (e.type == PladformAdModuleEvent.READY)
            {
                isModuleLoaded  = true;
                dispatchEvent(new PladformAdModuleEvent(PladformAdModuleEvent.READY))
            }
        }
        
        // PRIVATE METHODS
    }

}