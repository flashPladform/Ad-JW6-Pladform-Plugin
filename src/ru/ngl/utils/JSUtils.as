package ru.ngl.utils 
{
    import flash.external.ExternalInterface;
    /**
     * Утилиты работы со страницей
     * @author Alexander Semikolenov
     */
    public class JSUtils 
    {
        static private var _pagePath    :String = null; //Ссылка на страницу
        static private var _browser     :String = null; //браузер
        static private var iFrame       :int    = 0;    //индекс для определения айфрейма
        
        public function JSUtils() 
        {
            
        }
        
        // STATIC METHODS
         
        // ACCESSORS
        
        // PUBLIC METHODS
        
        CONFIG::IPLAYER
        {
        static public function setPagePath(path:String):void
        {
            _pagePath = path;
        }
        }
        /**
         * Сслка на страницу
         */
        static public function get pagePath():String
        {
            if (!_pagePath)
            {
                try
                {
                    if (ExternalInterface.available)
                    {
                        _pagePath = ExternalInterface.call("window.location.href.toString");
                    }
                    else
                    {
                        _pagePath = "";
                    }
                }
                catch (e:Error)
                {
                    _pagePath = "";
                }
            }
            
            return _pagePath;
        }
        /**
         * Браузер
         */
        static public function get browser():String
        {
            if (!_browser)
            {
                try
                {
                    if (ExternalInterface.available) 
                    {
                        _browser = ExternalInterface.call("function() { return navigator.appName+'('+navigator.appVersion+')'; }");
                    }
                    else
                    {
                        _browser = "";
                    }
                }
                catch (e:Error)
                {
                    _browser = ""
                }
            }
            
            return _browser
        }
        /**
         * Определение iFrame
         */
        static public function get isIFrame():Boolean
        {
            if (iFrame == 0)
            {
                try
                {
                    if(ExternalInterface.available)
                    {
                        var bool:Boolean = ExternalInterface.call("function () {if (window == window.top) return true; return false;}")
                        iFrame = (bool)?1:-1
                    }
                    else
                    {
                        iFrame = -1;
                    }
                }
                catch (err:Error)
                {
                    iFrame = -1;
                }
            }
            
            return (iFrame>0)?false:true;
        }
        /**
         * Определение существования функции по имени
         * @param functionName имя функции
         * @return флаг существования функции
         */
        static public function isExistJSFunctionByName(functionName:String):Boolean
        {
            try
            {
                if(ExternalInterface.available)
                {
                    return ExternalInterface.call("function(name) { if (typeof window[name] == 'function'){return true} return false; }", functionName);
                }
            }
            catch (err:Error) { }
            return false;
        }
        /**
         * ОПределение находится ли страница в субдомене
         * @param strDomain субдомен
         * @param page адрес страницы
         * @return находится ли страница в субдомене
         */
        static public function isSubDomain(strDomain:String, page:String=""):Boolean 
        {
            if (!page) page = pagePath;
            if (!page) return false;
            var arPage      :Array = page.split("/");
            var arDomain    :Array = strDomain.split("/").join("").split(".").reverse();
            while (arPage[1]=="")
            {
                arPage.splice(1,1);
            }
            
            var arPageDomain    :Array      = arPage[1].split(".");
            var isSub           :Boolean    = true;
            
            if(arDomain.length>arPageDomain.length)
            {
                return false
            }
            
            arPageDomain    = arPageDomain.reverse();
            
            for (var i:int = 0; i < arDomain.length; i++)
            {
                if (arPageDomain[i]!=arDomain[i])
                {
                    isSub = false;
                    break
                }
            }
            
            return isSub;
        }
        /**
         * Получение доменя по адресу страницы
         * @param adr адрес страницы
         * @return домен
         */
        static public function getDomain(adr:String):String
        {
            var arDomain    :Array  = adr.split("/")
            if(arDomain.length<3)
            {
                return "";
            }
            else
            {
                return arDomain[2];
            }
        }
        // EVENT HANDLERS
        
        // PRIVATE METHODS
        
    }

}