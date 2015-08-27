package ru.ngl.net 
{
	import flash.net.URLVariables;
	
	/**
	 * ...
	 * @author Alexander Semikolenov 
	 */
	public dynamic class CorrectURLVariables extends URLVariables 
	{
		/**
		 * Creates a new URLVariables object. You pass URLVariables
		 * objects to the data property of URLRequest objects.
		 * 
		 *   If you call the URLVariables constructor with a string, 
		 * the decode() method is automatically called
		 * to convert the string to properties of the URLVariables object.
		 * @param	source	A URL-encoded string containing name/value pairs.
		 * @langversion	3.0
		 * @playerversion	Flash 9
		 * @playerversion	Lite 4
		 */
		private var arFixParametters:Array = [];
		public function CorrectURLVariables(source:String=null) 
		{
			if (source) decode(source);
		}
		
		// STATIC METHODS
		
		// ACCESSORS
		
		// PUBLIC METHODS
		/**
		 * Converts the variable string to properties of the specified URLVariables object.
		 * This method is used internally by the URLVariables events. 
		 * Most users do not need to call this method directly.
		 * @param	source	A URL-encoded query string containing name/value pairs.
		 * @langversion	3.0
		 * @playerversion	Flash 9
		 * @playerversion	Lite 4
		 * @throws	Error The source parameter must be a URL-encoded query
		 *   string containing name/value pairs.
		 */
		override public function decode (source:String) : void
		{
			var arAparams	:Array	= source.split("&");
			var length		:int	= arAparams.length;
			for (var i:int = 0; i < length; i++) 
			{
				if (arAparams[i] != "")
				{
					var arValue	:Array		= arAparams[i].split("=");
					var valueName:String	= arValue.shift()
					if (!this[valueName])
					{
						arFixParametters.push(valueName);
					}
					this[valueName]	= (arValue.length > 0) ? arValue.join("=") : ""
					
				}
			}
		}
		/**
		 * Returns a string containing all enumerable variables, 
		 * in the MIME content encoding application/x-www-form-urlencoded.
		 * @return	A URL-encoded string containing name/value pairs.
		 * @langversion	3.0
		 * @playerversion	Flash 9
		 * @playerversion	Lite 4
		 */
		override public function toString () : String
		{
			var arParams	:Array	= [];
			var length		:int	= arFixParametters.length;
			var value		:String;
			for (var i:int = 0; i < length; i++) 
			{
				value	= arFixParametters[i]
				if (this[value] != null)
				{
					arParams.push(value + "=" + this[value]);
				}
			}
			for (value in this) 
			{
				if (arFixParametters.indexOf(value) == -1)
				{
					arParams.push(value + "=" + this[value]);
				}
			}
			return arParams.join("&");
		}
		
		// PROTECTED METHODS
		
		// EVENT HANDLERS
		
		// PRIVATE METHODS
		
	}

}