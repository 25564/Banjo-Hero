package Game {
	
	import flash.display.MovieClip;
	import flash.net.SharedObject;
	
	public class VolumeControl extends MovieClip {
		private var Config:SharedObject;
		
		public function VolumeControl() {
			this.Config = SharedObject.getLocal("Config");
		}
		
		public function Click(){
			if(Config.data.Volume == true){
				Config.data.Volume = false;
			} else {
				Config.data.Volume = true;
			}
			this.Update();
		}
		
		public function Update(){
			if(this.Config.data.hasOwnProperty("Volume")){
				if(this.Config.data.Volume == false){
					this.gotoAndStop(2);
				} else {
					this.gotoAndStop(1);	
				}	
			} else {
				this.Config.data.Volume = true;
				this.gotoAndStop(1);
			}
		}
	}
}
