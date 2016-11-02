package
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class ButtonRestart extends MovieClip
	{
		private var content:MovieClip;
		
		public function ButtonRestart(content:MovieClip)
		{
			this.content = content;
			addListener();
		}
		
		private function addListener():void
		{
			content.addEventListener(MouseEvent.CLICK, onContentClick);
		}
		
		private function onContentClick(event:MouseEvent):void
		{
			dispatchEvent(new Event(Constants.CLICK_RESTART));
		}
	}
}