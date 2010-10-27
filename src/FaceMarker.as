package
{
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	import mx.core.Container;

	public class FaceMarker extends Container
	{
		public var currentRect:Rectangle;
		private var lastDeparture:Date;
		private var newFaceBuffer:Number = 1000;
		
		public function FaceMarker()
		{
			this.setStyle("backgroundColor", "0xff0000");
			this.alpha = 0.4;
			this.visible = false;
			this.lastDeparture = new Date();
		}
		
		override public function set visible(value:Boolean):void
		{
			if(!this.visible && value) {
				handleNewFace();
			}
			if(this.visible && !value) {
				handleFaceLoss();
			}
			super.setVisible(value);
		}
		
		private function handleNewFace():void {
			var now:Date = new Date();
			if(now.getTime() - this.lastDeparture.getTime() > this.newFaceBuffer) {
				dispatchEvent(new Event(Event.ACTIVATE));
			}
		}
		
		private function handleFaceLoss():void {
			this.lastDeparture = new Date();
		}
	}
}