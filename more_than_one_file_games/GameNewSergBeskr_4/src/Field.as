package
{
	public class Field
	{
		private var _matrix:Array;
		
		public function Field()
		{
			filldMatrix();
		}

		public function get matrix():Array
		{
			return _matrix;
		}

		public function set matrix(value:Array):void
		{
			_matrix = value;
		}

		private function filldMatrix():void
		{
			matrix = [];
			var count:int = 0;
			for (var i:int = 0; i < Constants.SIZE; i++) {
				matrix[i] = [];
				for (var j:int = 0; j < Constants.SIZE; j++) {
					matrix[i][j] = Constants.START_POSITION[count];	
					count++;
				}
			}
			matrix[i-1][j-1] = 0;
		}
		
		public function restart():void
		{
			filldMatrix();	
		}
	}
}