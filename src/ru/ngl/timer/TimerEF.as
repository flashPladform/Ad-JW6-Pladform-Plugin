package ru.ngl.timer 
{
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	
	/**
	 * ...
	 * @author Alexander Semikolenov 
	 */
	public class TimerEF extends EventDispatcher//Timer 
	{
		private var currentTime		:Number =0;
		private var lastTime_old	:Number	=0;
		private var lastTime_new	:Number	=0;
		
		private var _delay			:Number;
		private var _repeatCount	:int;
		private var _currentCount	:int;
		private var isRunning		:Boolean;
		private var stage			:Stage;
		
		public function TimerEF(stage:Stage, delay:Number, repeatCount:int=0) 
		{	
			//super(delay, repeatCount);
			this.stage		= stage;
			_repeatCount	= repeatCount;
			_delay			= delay;
		}
		
		// STATIC METHODS
 		
		// ACCESSORS
		/**
		 * Общее число запусков, на которое настроен таймер. Если количество повторений содержит значение 0, таймер продолжает работу бесконечно до вызова метода stop(), либо до останова программы. Если количество повторений не равно нулю, таймер запускается указанное количество раз. Если значение количества повторений repeatCount совпадает со значением текущей итерации currentCount или меньше его, таймер останавливается и не запускается снова. 
		 */
		public function get repeatCount():int 
		{
			return _repeatCount;
		}
		
		public function set repeatCount(value:int):void 
		{
			_repeatCount = value;
		}
		/**
		 * Задержка в миллисекундах между событиями таймера, зависящая от частоты кадров. Если установить интервал задержки во время работы таймера, таймер будет перезапущен на текущей итерации repeatCount. 
		 */
		public function get delay():Number 
		{
			return _delay;
		}
		
		public function set delay(value:Number):void 
		{
			currentTime = 0;
			_delay = value;
		}
		/**
		 * Общее число срабатываний таймера с момента его запуска с нуля. Если таймер сбрасывается, учитываются только срабатывания после сброса. 
		 */
		public function get currentCount():int
		{
			return _currentCount;
		}
		/**
		 * Текущее состояние таймера: если таймер выполняется, то true, в противном случае - false. 
		 */
		public function get running():Boolean
		{
			return isRunning;
		}
		
		// PUBLIC METHODS
		/**
		 * Останавливает таймер, если он выполняется, и заново присваивает свойству currentCount значение 0, аналогично кнопке сброса на секундомере. Затем, при вызове метода start() экземпляр выполняется количество раз, определяемое значением repeatCount. 
		 */
		public function reset():void
		{
			_currentCount = 0;
			currentTime = 0;
			stop()
		}	
		public function start():void
		{
			isRunning = true;
			getDelay();
			stage.addEventListener(Event.ENTER_FRAME, enterFrameHandler)
		}
		public function stop():void
		{
			isRunning = false;
			stage.removeEventListener(Event.ENTER_FRAME, enterFrameHandler)
		}
		// EVENT HANDLERS
		
		private function enterFrameHandler(e:Event):void 
		{
			updateCurrentCount();
			if (
				_repeatCount > 0 && 
				_currentCount >= _repeatCount
				)
			{
				stage.removeEventListener(Event.ENTER_FRAME, enterFrameHandler)
				dispatchEvent(new TimerEvent(TimerEvent.TIMER_COMPLETE));
			}
		}
		
		// PRIVATE METHODS
		
		private function updateCurrentCount():void 
		{
			currentTime += getDelay();
			if (currentTime > delay)
			{
				currentTime = currentTime - delay;
				_currentCount++;
				dispatchEvent(new TimerEvent(TimerEvent.TIMER));
			}
		}
		
		private function getDelay():Number
		{
			lastTime_old	= lastTime_new
			lastTime_new	= (new Date() as Date).time;
			return lastTime_new - lastTime_old;
		}
		
	}

}