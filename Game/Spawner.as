package Game {

	import Game.Config;
	import Game.Dot;
	
	public class Spawner {

		private var SpawnChance:Number;
		
		public function Spawner() {
			this.SpawnChance = Config.SpawnChance;
		}
		
		public function ShouldSpawn():Boolean {
			if (Math.random() < SpawnChance){
				if(Math.random() < Config.IncrementChance){
					this.SpawnChance = this.SpawnChance + Config.DifficultyIncrement
					trace(this.SpawnChance);
				}
				return true;
			}
			return false;
		}
		
		public function create():Dot {
			var TempDot:Dot = new Dot();
			return TempDot;
		}

	}
	
}
