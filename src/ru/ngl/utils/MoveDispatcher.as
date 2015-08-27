package ru.ngl.utils 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import ru.ngl.timer.TimerEF;
	/**
	 * ...
	 * @author Alexander Semikolenov 
	 */
	public class MoveDispatcher extends Sprite
	{
		static public const MOVE	:String = "MoveDispatcher.MOVE";
		
		private var timer			:TimerEF;
		private var _x				:Number = 0;
		private var _y				:Number = 0;
		private var _delay			:Number;
		
		public function MoveDispatcher(delay:Number) 
		{
			_delay = delay;
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
		
		public function get delay():Number 
		{
			return _delay;
		}
		
		public function set delay(value:Number):void 
		{
			if (timer)
			{
				timer.delay = value;
				timer.start();
			}
			_delay = value;
		}
		
		// PUBLIC METHODS
		
		public function start():void
		{
			if (timer)
			{
				timer.start();
			}
		}
		
		public function stop():void
		{
			if (timer)
			{
				timer.reset();
			}
		}
		
		// EVENT HANDLERS
		
		private function removeFromStageHandler(e:Event):void 
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, removeFromStageHandler);
			timer.stop();
			timer.removeEventListener(TimerEvent.TIMER, timerHandler)
		}
		
		private function timerHandler(e:TimerEvent):void 
		{
			if (_x != mouseX ||
				_y != mouseY)
			{
				_x = mouseX;
				_y = mouseY;
				dispatchEvent(new Event(MOVE));
			}
		}
		
		private function addToStageHandler(e:Event):void 
		{
			_x = mouseX;
			_y = mouseY;
			removeEventListener(Event.ADDED_TO_STAGE, addToStageHandler);
			addEventListener(Event.REMOVED_FROM_STAGE, removeFromStageHandler)
			timer = new TimerEF(stage, delay);
			timer.addEventListener(TimerEvent.TIMER, timerHandler)
			timer.start();
		}
		
		// PRIVATE METHODS
		
	}

}