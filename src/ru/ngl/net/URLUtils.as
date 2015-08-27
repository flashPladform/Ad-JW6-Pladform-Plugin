package ru.ngl.net 
{
	/**
	 * ...
	 * @author Alexander Semikolenov
	 */
	public class URLUtils 
	{
		
		public function URLUtils() 
		{
			
		}
		
		// STATIC METHODS
		static public function removeProtocol(str:String):String
		{
			CONFIG::release
			{
				return str.split("http:").join("")
			}
			return str
		}
		// ACCESSORS
		
		// PUBLIC METHODS
		
		// PROTECTED METHODS
		
		// EVENT HANDLERS
		
		// PRIVATE METHODS
		
	}

}