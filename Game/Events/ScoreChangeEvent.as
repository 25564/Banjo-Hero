package Game.Events{
	import flash.events.Event;

	public class ScoreChangeEvent extends Event {

		public static const SCORE_CHANGED:String = 'scoreChanged';

		private var _score:int;

		public function get score():int {
			return _score;
		}

		public function ScoreChangeEvent(score:int) {
			super(SCORE_CHANGED, true, false);
			this._score = score;
		}

		override public function clone():Event {
			return new ScoreChangeEvent(_score);
		}
	}
}