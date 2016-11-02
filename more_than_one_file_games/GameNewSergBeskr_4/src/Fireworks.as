package
{
	import flash.display.MovieClip;
	
	public class Fireworks extends MovieClip
	{
		private var content:MovieClip;
		
		public function Fireworks(content:MovieClip)
		{
			this.content = content;
			updateFireworks(false);
		}
		
		public function updateFireworks(param:Boolean):void
		{
			content.visible = param;
		}
	}
}