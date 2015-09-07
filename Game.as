package {
	import flash.ui.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.display.*;	
	import flash.text.*;
	import flash.utils.*;
	import flash.media.Sound;
	import flash.net.SharedObject;
	import flash.media.SoundChannel;

	import Game.*;
	import Game.Events.*;
	import Music;

	public class Game extends MovieClip {
		
		public var PlayerScore:ScoreController;
		private var SpawnController:Spawner;
		
		
		/*------------ Config -------------*/
		private var PlayerMusic:Boolean = true;
		
		/*---------------------------------*/
		
		
		
		private var GameState:Number = 0;
		
		/*--------- Game Stages ----------
	
			0 = Game Run Loop
			1 = Game Over
			2 = Game Paused
		
		--------------------------------*/
	
		
		private var LoseStreak:Number = 0;
		
		private var ActiveDots:Array = new Array(); //Store all Dots currently active.
		private var Keys:Array = [false,false,false,false,false];	
		private var KeyQ:Boolean = false,KeyW:Boolean = false,KeyE:Boolean = false,KeyO:Boolean = false,KeyP:Boolean = false;
		private var backgroundMusic:SoundChannel;
		private var PlayerConfig:SharedObject;
		
		public function Game() {
			/*
				Class is being manually started by Initialize() due to the constructor
				being called before the game was ready to start.
			*/
		}
		
		public function Initialize(){
			this.PlayerScore = new ScoreController();
			this.SpawnController = new Spawner();
			
			this.PlayerConfig = SharedObject.getLocal("Config");
			if(this.PlayerConfig.data.hasOwnProperty("Volume")){
				this.PlayerMusic = this.PlayerConfig.data.Volume;
			} else {
				this.PlayerConfig.data.Volume = true;
				this.PlayerMusic = this.PlayerConfig.data.Volume;
			}
		
			//Game Loop and Input monitoring
			GameStage.addEventListener(Event.ENTER_FRAME, Update);
			addEventListener(Event.ADDED_TO_STAGE, InitializeStage );
			this.PlayerScore.addEventListener(Game.Events.ScoreChangeEvent.SCORE_CHANGED, UpdateScore);
			stage.addEventListener(KeyboardEvent.KEY_DOWN,KeyDownController);
			
			this.Restart();
			if(this.PlayerMusic == true){
				var BackgroundSong:Sound = new Music();
				this.backgroundMusic = new SoundChannel();
				backgroundMusic = BackgroundSong.play(0, 9999);
			}
		}
		
		public function Restart():void{
			this.ActiveDots = new Array();
			this.ActiveDots[0] = new Array();
			this.ActiveDots[1] = new Array();
			this.ActiveDots[2] = new Array();
			this.ActiveDots[3] = new Array();
			this.ActiveDots[4] = new Array();
			this.PlayerScore.score = 0;
			this.LoseStreak = 0;
			this.GameState = 0;
		}
		
		
		/*============================================
					   Primary Game Loop 
		============================================*/		
		
		public function Update(evt:Event):void {
			if(this.GameState == 0){
				if(this.ActiveDots.length == 5){
					if (this.SpawnController.ShouldSpawn() == true){
						var TempDot:Dot = this.SpawnController.create();
						this.ActiveDots[TempDot.getIndex()].push(TempDot);
						GameStage.addChild(TempDot);
					}
									
					//Update Dots
					for (var j=this.ActiveDots.length - 1; j >= 0; j--){
						if(this.GameState == 0){
							for (var i=this.ActiveDots[j].length - 1; i >= 0; i--){
								this.ActiveDots[j][i].update();
								if (this.ActiveDots[j][i].InScreen() == false) {
									GameStage.removeChild(this.ActiveDots[j][i]);
									this.ActiveDots[j].splice(i,1);		
									this.PlayerScore.subtract(2);
									this.AddMistake();
									if(this.GameState > 0){
										break
									}
								}
							}
						} else {
							break;

						}
					}
					
					var KeysPressed:Array = [this.KeyQ,this.KeyW,this.KeyE,this.KeyO,this.KeyP];
					for (var k=KeysPressed.length - 1; k >= 0; k--){
						if(KeysPressed[k]){
							if(this.CheckPositions(k) == false){
								this.AddMistake();
							} else {
								this.LoseStreak = 0;
							}
						}
					}
					this.KeyQ = false,this.KeyW = false,this.KeyE = false,this.KeyO = false,this.KeyP = false;
				}
			}
		}
		
		/*============================================
					 Helpers Functions 
		============================================*/		
		private function CheckPositions(Index:Number):Boolean{
			for (var i=this.ActiveDots[Index].length - 1; i >= 0; i--){
				var PerfectDif = Config.PerfectY - this.ActiveDots[Index][i].y;
				if(PerfectDif > 0 - Config.ErrorMargin && PerfectDif < 0 + Config.ErrorMargin){ //Perfect Hit
					GameStage.removeChild(ActiveDots[Index][i]);
					this.ActiveDots[Index].splice(i,1);
					this.PlayerScore.add(6);
					return true;
				} else if(PerfectDif > 0 - (Config.ErrorMargin*2) && PerfectDif < 0 + (Config.ErrorMargin*2)){ //Close Enough
					this.PlayerScore.add(4);
					GameStage.removeChild(ActiveDots[Index][i]);
					this.ActiveDots[Index].splice(i,1);
					return true;
				} else { //Do you even have eyes
					this.PlayerScore.subtract(2);
				}
			}
			return false;
		}
		
		private function AddMistake() {
			this.LoseStreak = this.LoseStreak + 1;
			if(this.LoseStreak >= Config.LoseTolerance){
				this.GameOver();
			}
		}

		private function GameOver(){
			this.GameState = 1;
			var FinalScore = SharedObject.getLocal("Score");
			FinalScore.data.Score = this.PlayerScore.score; 
			if(this.PlayerMusic == true){
				this.backgroundMusic.stop();
			}
			this.Restart();
			GameStage.removeEventListener(Event.ENTER_FRAME, Update);
			this.PlayerScore.removeEventListener(Game.Events.ScoreChangeEvent.SCORE_CHANGED, UpdateScore);
			stage.removeEventListener(KeyboardEvent.KEY_DOWN,KeyDownController);
			MovieClip(this.root).nextScene();
			
		}

	
		/*============================================
					Private Event Functions 
		============================================*/
		
		private function InitializeStage(evt: Event):void {
			stage.addEventListener(KeyboardEvent.KEY_DOWN,KeyDownController);
		}  
		
		private function KeyDownController(evt:KeyboardEvent):void {
			switch (evt.keyCode){
				case 81:// Letter Q
					this.KeyQ = true;
				break;
				case 87:// Letter W
					this.KeyW = true;
				break;
				case 69:// Letter E
					this.KeyE = true;
				break;
				case 79:// Letter O
					this.KeyO = true;
				break;
				case 80:// Letter P
					this.KeyP = true;
				break;
			}
		}
		
		private function UpdateScore(evt:ScoreChangeEvent):void {
			PlayerScoreText.text = evt.score.toString();
		}
	}
	
}
