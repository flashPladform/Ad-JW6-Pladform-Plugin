package ru.ngl.display 
{
    import flash.display.Sprite;
    import flash.events.Event;
    import ru.ngl.utils.ResizeObject;
    /**
     * Спрайт у которого есть ResizeObject, для сообщения изменения размеров.
     * @author Alexander Semikolenov 
     */
    public class SpriteStretchy extends Sprite
    {
        protected var _resizeObject        :ResizeObject; // габариты спарйта
        private var resizeObject_income    :ResizeObject; // приоритетные габариты, если не указаны, ориентируемся на stage
        
        public function SpriteStretchy(resizeObject:ResizeObject = null) 
        {
            resizeObject_income = resizeObject;
            
            if (stage)
            {
                addToStageHandler(null);
            }
            else
            {
                addEventListener(Event.ADDED_TO_STAGE, addToStageHandler)
            }
        }
        
        // STATIC METHODS
         
        // ACCESSORS
        /**
         * габариты спрайта
         */
        public function get resizeObject():ResizeObject 
        {
            return _resizeObject;
        }
        
        // PUBLIC METHODS
        /**
         * установка габаритов
         * @param resObject
         */
        public function initResizeObject(resObject:ResizeObject)
        {
            if(resizeObject_income) resizeObject_income.removeEventListener(Event.RESIZE, resizeHandler);
            stage.removeEventListener(Event.RESIZE, resizeHandler);
            
            resizeObject_income        = resObject;
            
            if (resizeObject_income)
            {
                resizeObject_income.addEventListener(Event.RESIZE, resizeHandler);
                resizeObject_income.dispatchEvent(new Event(Event.RESIZE))
            }
            else
            {
                stage.addEventListener(Event.RESIZE, resizeHandler);
            }
        }
        
        // EVENT HANDLERS
        
        private function removeHandler(e:Event):void 
        {
            removeEventListener(Event.REMOVED_FROM_STAGE, removeHandler);
            stage.removeEventListener(Event.RESIZE, resizeHandler);
            if(resizeObject_income) resizeObject_income.removeEventListener(Event.RESIZE, resizeHandler);
        }
        /**
         * обработка ресайза, задание габаритов
         * @param e
         */
        private function resizeHandler(e:Event):void 
        {
            if (!resizeObject_income)
            {
                _resizeObject.update(0, 0, stage.stageWidth, stage.stageHeight);
            }
            else
            {
                _resizeObject.update(resizeObject_income.x, resizeObject_income.y, resizeObject_income.width, resizeObject_income.height);
            }
        }
        
        private function addToStageHandler(e:Event):void 
        {
            removeEventListener(Event.ADDED_TO_STAGE, addToStageHandler);
            addEventListener(Event.REMOVED_FROM_STAGE, removeHandler)
            
            _resizeObject = new ResizeObject();
            
            if (resizeObject_income)
            {
                resizeObject_income.addEventListener(Event.RESIZE, resizeHandler);
            }
            else
            {
                stage.addEventListener(Event.RESIZE, resizeHandler);
            }
            resizeHandler(null)
        }
        
        // PRIVATE METHODS
        
    }

}