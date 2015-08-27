//Класс для кнопков 
//ru.ngl.buttons.AnimBatton
package ru.ngl.buttons
{
	/**
	 * ...
	 * @author Alexander Semikolenov
	 * @version 1.2
	 */
	
	import flash.display.FrameLabel;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	public class AnimBatton extends MovieClip
	{
		protected var is_activ	:Boolean;
		protected var is_in		:Boolean;
		//protected var is_activ:Boolean;
		
		/**
		 * 
		 * @param	activ_mode Активность кнопки
		 */
		public function AnimBatton(activ_mode:Boolean = true)
		{
			mouseChildren = false;
			is_activ = false;
			if (activ_mode){
				activate();
			};
			var arFrameNames:Array = ["hide", "in", "view", "out"];
			
			for (var i:int = 0; i < currentLabels.length; i++) 
			{
				var fl:FrameLabel =  currentLabels[i];
				if (arFrameNames.indexOf(fl.name) == -1)
				{
					throw new Error("not AnimBatton");
				}
				
				if (fl.name == "hide" || fl.name == "view")
				{
					addFrameScript(fl.frame-1, stop);
				}
			}
			
		}
		public function playOver(e:MouseEvent = null):void
		{
			gotoAndPlay("in");
		}
		
		public function playOut(e:MouseEvent = null):void
		{
			gotoAndPlay("out");
		}
		
		
		public function set active(bool:Boolean):void
		{
			if (bool)
			{
				activate();
			}
			else
			{
				deactivate();
			}
		}
		
		public function get active():Boolean
		{
			return is_activ;
		}
		
		private function deactivate():void
		{
			if (is_activ)
			{
				is_activ	= false;
				buttonMode	= false;
				removeEventListener(MouseEvent.MOUSE_OVER, playOver);
				removeEventListener(MouseEvent.MOUSE_OUT, playOut);
			}
		}
		
		private function activate():void
		{
			if (!is_activ)
			{
				is_activ	= true;
				buttonMode	= true;
				addEventListener(MouseEvent.MOUSE_OVER, playOver);
				addEventListener(MouseEvent.MOUSE_OUT, playOut);
			}
		}
		
		public function markView():void
		{
			gotoAndStop("view");
		}
		
		public function markHide():void
		{
			gotoAndStop("hide");
		}
	}
}