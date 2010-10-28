package
{
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	import mx.core.Container;

	public class FaceMarker extends Container
	{
		public var currentRect:Rectangle;
		private var lastDeparture:Date;
		private var lastArrival:Date;
		private var waitingForNext:Boolean;
		private var newFaceBuffer:Number = 2000;
		private var minLifeTime:Number = 1500;
		
		public function FaceMarker()
		{
			this.setStyle("backgroundColor", "0xff0000");
			this.alpha = 0.4;
			this.visible = false;
			
			this.lastArrival = new Date();
			this.lastDeparture = new Date();
			this.lastDeparture.setTime(0);
			this.waitingForNext = true;
		}
		
		override public function set visible(value:Boolean):void
		{
			if(!this.visible && value) {
				handleNewFace();
			}
			if(this.visible && !value) {
				handleFaceLoss();
			}
			if(this.visible && value) {
				handleOldFace();
			}
			super.setVisible(value);
		}
		
		private function handleOldFace():void {
			var now:Date = new Date();
			if(
				now.getTime() - this.lastDeparture.getTime() > this.newFaceBuffer  //It's been off screen for a while (it's a new person)
				&& now.getTime() - this.lastArrival.getTime() > this.minLifeTime //It's been on screen for long enough (it's not a flicker)
				&& waitingForNext == true
			) {
				trace("lifetime: " + (now.getTime() - this.lastArrival.getTime()));
				dispatchEvent(new Event(Event.ACTIVATE));
				this.waitingForNext = false;
			}
		}
		
		private function handleNewFace():void {
			this.lastArrival = new Date();
		}
		
		private function handleFaceLoss():void {
			waitingForNext = true;
			this.lastDeparture = new Date();
		}
	}
}