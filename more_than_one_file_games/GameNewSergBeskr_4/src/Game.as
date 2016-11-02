package
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import fl.transitions.Tween;
	import fl.transitions.TweenEvent;
	import fl.transitions.easing.None;
	
	public class Game extends Sprite
	{
		private var plates:Array = [];
		private var field:Field;
		private var btnRestart:ButtonRestart;
		private var isAnimation:Boolean;
		private var fireworks:Fireworks;
		
		public function Game()
		{
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			new EmbededResources(this);
		}
		
		public function addedResourcesToStage(gameField:MovieClip):void
		{
			stage.addChild(gameField);
			
			initPlates(gameField);
			iniBtnRestart(gameField);
			initFireworks(gameField);
			
			onClickRestart(null);
		}
		
		private function initPlates(gameField:MovieClip):void
		{
			var mcPlate:MovieClip;
			var plate:Plate;
			for (var i:int = 0; i < Constants.PLATE_VALUE; i++) {
				mcPlate = gameField.getChildByName(Constants.PLATE+i) as MovieClip;
				plate = new Plate(mcPlate, Constants.START_POSITION[i]);
				plates.push(plate);
			}
			field = new Field();
			addPlateListeners();
		}
		
		private function iniBtnRestart(gameField:MovieClip):void
		{
			var restart:MovieClip = gameField.getChildByName(Constants.BTN_RESTART) as MovieClip;
			btnRestart = new ButtonRestart(restart);
			
			addRestartListener();
			
		}
		
		private function initFireworks(gameField:MovieClip):void
		{
			var mcFireworks:MovieClip = gameField.getChildByName(Constants.FIREWORKS) as MovieClip; 
			fireworks = new Fireworks(mcFireworks); 
			
		}
		
		private function addRestartListener():void
		{
			btnRestart.addEventListener(Constants.CLICK_RESTART, onClickRestart);
			
		}
		
		private function addPlateListeners():void
		{
			var plate:Plate;
			for(var i:int = 0; i < plates.length; i++) {
				plate = plates[i] as Plate;
				plate.addEventListener(Constants.CLICK_PLATE, onClickPlate);
			}
		}
		
		private function onClickPlate(event:Event):void
		{
			if(isAnimation) return;
			
			var plate:Plate = event.currentTarget as Plate;
			var index:int = plate.getContent().currentFrame;
			var matrix:Array = field.matrix;
			var row:int = -1;
			var col:int = -1;
			
			for(var i:int = 0; i<matrix.length; i++) {
				for(var j:int = 0; j<matrix[i].length; j++) {
					if(matrix[i][j] == index) {
						row = i;
						col = j;
						break;
					}
					if(row > -1) {
						break;
					}
				}	
			}
			
			checkEmptyPlace(row,col, plate);
		}
		
		private function checkEmptyPlace(row:int, col:int, plate:Plate):void
		{
			var matrix:Array = field.matrix;
			var mcPlate:MovieClip = plate.getContent();
			
			if((col-1) > -1 && matrix[row][col-1] == 0) {
				//mcPlate.x -= mcPlate.width;
				startTweenAnimation(mcPlate, Constants.LEFT);
				matrix[row][col] = 0;
				matrix[row][col-1] = mcPlate.currentFrame;
			}
			
			if((col+1) < Constants.SIZE && matrix[row][col+1] == 0) {
				//mcPlate.x += mcPlate.width;
				startTweenAnimation(mcPlate, Constants.RIGHT);
				matrix[row][col] = 0;
				matrix[row][col+1] = mcPlate.currentFrame;
			}
			
			if((row-1) > -1 && matrix[row-1][col] == 0) {
				//mcPlate.y -= mcPlate.height;
				startTweenAnimation(mcPlate, Constants.UP);
				matrix[row][col] = 0;
				matrix[row-1][col] = mcPlate.currentFrame;
			}
			
			if((row+1) < Constants.SIZE && matrix[row+1][col] == 0) {
				//mcPlate.y += mcPlate.height;
				startTweenAnimation(mcPlate, Constants.DOWN);
				matrix[row][col] = 0;
				matrix[row+1][col] = mcPlate.currentFrame;
			}
		}
		
		private function startTweenAnimation(plate:MovieClip, direction:String):void
		{
			isAnimation = true;
			
			var tween:Tween;
			
			if(direction == Constants.RIGHT) {
				tween = new Tween(plate, Constants.DIRECTION_X, None.easeInOut, plate.x, plate.x+plate.width, Constants.TIMING, true);
			}
			
			if(direction == Constants.LEFT) {
				tween = new Tween(plate, Constants.DIRECTION_X, None.easeInOut, plate.x, plate.x-plate.width, Constants.TIMING, true);
			}
			
			if(direction == Constants.UP) {
				tween = new Tween(plate, Constants.DIRECTION_Y, None.easeInOut, plate.y, plate.y-plate.height, Constants.TIMING, true);
			}
			
			if(direction == Constants.DOWN) {
				tween = new Tween(plate, Constants.DIRECTION_Y, None.easeInOut, plate.y, plate.y+plate.height, Constants.TIMING, true);
			}
			tween.addEventListener(TweenEvent.MOTION_FINISH, onAnimationFinish);
		}
		
		private function onAnimationFinish(event:TweenEvent):void
		{	
			var tween:Tween = event.currentTarget as Tween;
			tween.removeEventListener(TweenEvent.MOTION_FINISH, onAnimationFinish);
			isAnimation = false;
			
			checkWin();
		}
		
		private function checkWin():void
		{
			var matrix:Array = field.matrix;
			var count:int = 1;
			for(var i:int = 0; i<matrix.length; i++) {
				for(var j:int = 0; j<matrix[i].length; j++) {
					if(i+j == ((Constants.SIZE-1) + (Constants.SIZE-1))) break;
					if(matrix[i][j] != count)  {
						return;
					}
					count++;
				}
			}
			isAnimation = true;
			fireworks.updateFireworks(true);
		}
		
		private function onClickRestart(event:Event):void
		{
			if(isAnimation) return;
			
			fireworks.updateFireworks(false);
			
			field.restart();
			var plate:Plate;
			var mcPlate:MovieClip;
			var count:int = 0;
			for(var i:int = 0; i<Constants.SIZE; i++) {
				for(var j:int = 0; j<Constants.SIZE; j++) {
					plate = plates[count];
					if(plate) {
						mcPlate = plate.getContent();
						mcPlate.x = mcPlate.width*j; 
						mcPlate.y = mcPlate.height*i; 
						count++;
					}
				}
			}
//			isAnimation = true;
//			fireworks.updateFireworks(true);
		}
	}
}