package Game
{
	import flash.display.MovieClip;
	import Game.Config;
	
	public class Dot extends MovieClip {		
		
		private var colourIndex:Number; 
		
		public function Dot(){
			this.colourIndex = Math.floor(Math.random()*5);
			this.x = Config.DotStartX[colourIndex];
			this.y = Config.DotStartY;
			
			this.gotoAndStop(this.colourIndex + 1);
		}
		
		public function update(){
			this.y += Config.BrickSpeed;
		}
		
		public function getIndex():Number {
			return this.colourIndex;
		}
		
		public function InScreen():Boolean {
			return this.y < Config.VanishPoint;
		}
	}
}