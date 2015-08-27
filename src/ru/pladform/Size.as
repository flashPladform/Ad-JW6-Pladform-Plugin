package ru.pladform 
{

    /**
     * Габариты
     * @author Alexander Semikolenov
     */
    public class Size 
    {
        /**
         * Ширина
         */
        public var width   :Number;
        /**
         * Высота
         */
        public var height  :Number;
        
        public function Size() 
        {
            
        }
        
        // STATIC METHODS
        
        // ACCESSORS
        // PUBLIC METHODS
        /**
         * Задать габариты
         * @param width ширина
         * @param height высота
         */
        public function resize(width:Number, height:Number):void
        {
            this.height = height;
            this.width  = width;
            
        }
        // PROTECTED METHODS
        
        // EVENT HANDLERS
        
        // PRIVATE METHODS
    }

}