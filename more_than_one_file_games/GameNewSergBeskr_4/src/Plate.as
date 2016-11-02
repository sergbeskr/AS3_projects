package
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class Plate extends MovieClip
	{
		private var content:MovieClip;
		
		public function Plate(content:MovieClip, frame:int)
		{
			this.content = content;
			content.gotoAndStop(frame);
			addListeners();
		}
		
		private function addListeners():void
		{
			content.addEventListener(MouseEvent.CLICK, onClickContent);
		}
		
		private function onClickContent(event:MouseEvent):void
		{
			dispatchEvent(new Event(Constants.CLICK_PLATE));
		}
		
		public function getContent():MovieClip
		{
			return content;
		}
	}
}