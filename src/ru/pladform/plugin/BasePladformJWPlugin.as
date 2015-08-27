package ru.pladform.plugin 
{
    import com.longtailvideo.jwplayer.events.MediaEvent;
    import com.longtailvideo.jwplayer.player.IPlayer;
    import com.longtailvideo.jwplayer.plugins.IPlugin6;
    import com.longtailvideo.jwplayer.plugins.PluginConfig;
    import flash.display.Sprite;
    import flash.system.Security;
    import ru.pladform.Size;
    
    /**
     * БАзовый клас для взаисодействия с API JWPlayer
     * @author Alexander Semikolenov
     */
    public class BasePladformJWPlugin extends Sprite implements IPlugin6 
    {
        /**
         * Типа воспроизводимого видео live или vod
         */
        protected var isLive       :Boolean = true;
        
        /**
         * Интерфейс управления плееров согласно API JWPlayer
         */
        protected var player        :IPlayer;
        
        /**
         * Габариты плеера
         */
        protected var playerSize    :Size;
        
        public function BasePladformJWPlugin() 
        {
            Security.allowDomain("*");
            playerSize = new Size();
        }
        
        /* INTERFACE com.longtailvideo.jwplayer.plugins.IPlugin6 */
        
        /**
         * Целевая венрсия API JWPlayer
         */
        public function get target():String 
        {
            return "6.0";
        }
        
        /**
         * Инициализация плагина, API JWPlayer
         * @param player объект для управления плеером
         * @param config конфигурационные данные для инициализации плагина
         */
        public function initPlugin(player:IPlayer, config:PluginConfig):void 
        {
            this.player = player;
            player.addEventListener(MediaEvent.JWPLAYER_MEDIA_TIME, liveDetectHandler);
        }
        
        /**
         * Изменение размера плеера API JWPlayer
         * @param width ширина
         * @param height высота
         */
        public function resize(width:Number, height:Number):void 
        {
            playerSize.resize(width, height)
        }
        
        /**
         * Идентификатор плагина, по совмещению его же имя файла.
         */
        public function get id():String 
        {
            return "pladform_jw";
        }
        
        // STATIC METHODS
        
        // ACCESSORS
        
        // PUBLIC METHODS
        
        // PROTECTED METHODS
        
        /**
         * Реакция на блокировку плеера
         */
        protected function lockHandler():void
        {
            trace("lock")
        }
        
        /**
        * Возобновить воспроизведение видео
        */
        protected function resumeVideo():void
        {
            player.unlock(this);
            if (!player.play())
            {
                player.pause();
                player.play();
            }
        }
        
        /**
         * Поставить воспроизведение видео на паузу
         */
        protected function pauseVideo():void
        {
            player.unlock(this);
            player.pause();
            player.lock(this, lockHandler);
        }
        // EVENT HANDLERS
        
        /**
         * Определение типа воспроизводимого видео live или vod
         * @param e
         */
        private function liveDetectHandler(e:MediaEvent):void 
        {
            //Если во время воспроизведение получаем позицию воспроизведения, считаем, что это не live поток 
            if (e.position > 0)
            {
                player.removeEventListener(MediaEvent.JWPLAYER_MEDIA_TIME, liveDetectHandler);
                isLive = false;
            }
        }
        
        // PRIVATE METHODS
    }

}