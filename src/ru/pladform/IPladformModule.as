package ru.pladform 
{
	import flash.net.URLVariables;
	
	/**
	 * ...
	 * @author Alexander Semikolenov (alex@semikolenov.ru)
	 */
	public interface IPladformModule 
	{
		/**
		 * Инициализация модуля перед началом показа видеоролика, параметры передаются через объект URLVariables, который, параметры которого участвуют в запросе рекламы. 
		 * @param	vars передаваемые параметры в формате URLVariables.Свойство pl в vars является обязательным
		 */
		function init(vars:URLVariables):void
	}
}