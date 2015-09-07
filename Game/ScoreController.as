package Game {
	import flash.events.EventDispatcher;
	import Game.Events.ScoreChangeEvent;
	[Event(name="scoreChanged", type="ScoreChangeEvent")]

	public class ScoreController extends EventDispatcher{
		private var _score:int;

		public function get score():int {
			return this._score;
		}

		public function set score(value:int):void {
			if (this._score == value) {
				return;
			}
			this._score = value;
			this.dispatchEvent(new Game.Events.ScoreChangeEvent(this._score));
		}

		public function ScoreController() {
		}

		public function reset():void {
			this.score = 0;
		}

		public function add(value:int):void {
			this.score = this.score + value;
		}
		
		public function subtract(value:int):void {
				this.score = this.score - value;
		}
	}
}