package ru.pladform 
{
	/**
	 * ...
	 * @author Alexander Semikolenov (alex@semikolenov.ru)
	 */
	public class AdType 
	{
		static public const PREROLL				:String	= "1";
		static public const PAUSE_BANNER		:String	= "2";
		static public const POSTROLL			:String	= "4";
		
		static public const MIDLE_ROLL			:String	= "7";
		static public const PAUSEROLL			:String	= "8";
		
		static public const ALL_ROLL			:String	= "9";
		
		public function AdType() {}
		
		// STATIC METHODS
		
		static public function asString(id:String):String
		{
			switch (id)
			{
				case PREROLL		: return "preroll";
				case PAUSE_BANNER	: return "pause_banner";
				case POSTROLL		: return "postroll";
				case MIDLE_ROLL		: return "midle_roll";
				case PAUSEROLL		: return "pauseroll";
				case ALL_ROLL		: return "all_roll";
			}
			return "unknow"
		}
 		
		// ACCESSORS
		
		// PUBLIC METHODS
		
		// EVENT HANDLERS
		
		// PRIVATE METHODS
		
	}

}