package ru.ngl.utils 
{
	/**
	 * ...
	 * @author Alexander Semikolenov
	 */
	public class URLEncoder 
	{
		
		public function URLEncoder() 
		{
			
		}
		
		// STATIC METHODS
		static public function encode(val:String):String
		{
			var str			:String	= encodeURIComponent(val);
			var arStr		:Array	= ["!",	"'", "(", ")", "*", "~"];
			var arStrEcr	:Array	= ["%21", "%27", "%28", "%29", "%2A", "%7E"];
			for (var i:int = 0; i < arStr.length; i++)
			{
				str = str.split(arStr[i]).join(arStrEcr[i]);
			}
			return str;
			
		}
		// ACCESSORS
		
		// PUBLIC METHODS
		
		// PROTECTED METHODS
		
		// EVENT HANDLERS
		
		// PRIVATE METHODS
		
	}

}