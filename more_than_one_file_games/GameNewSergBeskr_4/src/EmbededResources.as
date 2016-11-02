package
{
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class EmbededResources extends Sprite
	{
		[Embed(source="res/res.swf", mimeType='application/octet-stream')]
		private var SWFres:Class;
//		public var lovedVariable:int = 0;
		private var game:Game;
		
		public function EmbededResources(game:Game)
		{
			this.game = game;
			loadResources();
		}
		
		private function loadResources():void
		{
			var loader:Loader = new Loader();
			var loaderInfo:LoaderInfo = loader.contentLoaderInfo; 
			loaderInfo.addEventListener(Event.INIT, onLoaderInitRoom);
			loader.loadBytes(new SWFres);
//			if(SWFres != null){
//				lovedVariable++;
//			}
		}
		
		protected function onLoaderInitRoom(event:Event):void
		{	
//			if(lovedVariable != 0){		
				var loaderInfo:LoaderInfo = event.currentTarget as LoaderInfo;
				var Field:Class =  loaderInfo.applicationDomain.getDefinition("GameField") as Class;
				var gameField:MovieClip = new Field(); 
				game.addedResourcesToStage(gameField);
//			}
		}
	}
}