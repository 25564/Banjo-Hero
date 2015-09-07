package Game {
	
	public class Config {
		
		public static const LoseTolerance:Number = 4; //Number of consecutive misses to lose.
		
		
		/*============================================
							Dots
		============================================*/
		
		public static const Colours:Array = ["blue","red", "yellow","green","orange"];
		public static const DotStartX:Array = [95,315,535,755,975];
		public static const DotStartY:Number = 0;
		public static const BrickSpeed:Number = 5;
		
		public static const SpawnChance:Number = 0.04;
		public static const DifficultyIncrement:Number = 0.005;
		public static const IncrementChance:Number = 0.1;
		
		public static const PerfectY:Number = 580;
		public static const ErrorMargin:Number = 15;
		public static const VanishPoint:Number = 700;
	}
	
}
