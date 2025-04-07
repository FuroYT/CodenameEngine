package funkin.backend.system.framerate;

#if mobile

import funkin.backend.system.MobileInput;
class MobileInputInfo extends FramerateCategory {
	public function new() {
		super("Mobile Input Info");
	}

	public override function __enterFrame(t:Int) @:privateAccess {
		if (alpha <= 0.05) return;
		_text = "";
		for (touch in MobileInput.touchesTime.keys()) {
			var timeHeld = MobileInput.touchesTime.get(touch);
			var startPos = MobileInput.touchesStartPos.get(touch);
			var endPos = MobileInput.touchesPos.get(touch);

			_text += "Touch ID: " + touch + "\n";
			_text += "Time Held: " + timeHeld + "\n";
			_text += "Start Position: (" + startPos.x + ", " + startPos.y + ")\n";
			_text += "End Position: (" + endPos.x + ", " + endPos.y + ")\n\n";
		}

		this.text.text = _text;
		super.__enterFrame(t);
	}
}
#end