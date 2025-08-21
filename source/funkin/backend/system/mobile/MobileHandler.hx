package funkin.backend.system.mobile;

import funkin.backend.system.Controls;
import funkin.backend.system.mobile.input.SwipeUtil;
import funkin.backend.system.mobile.input.TouchUtil;
import funkin.options.PlayerSettings;

class MobileHandler
{
	public static function init() {
		#if mobile
		FlxG.signals.preUpdate.add(handleMobileInput);
		#end
	}

	static var controls(get, never):Controls;
	
	static inline function get_controls():Controls
		return PlayerSettings.solo.controls;

	static function handleMobileInput()
	{
		if (TouchUtil.justReleased) {
			controls.ACCEPT = true;
		} else {
			if (SwipeUtil.swipeLeft)
				controls.LEFT_P = true;
			if (SwipeUtil.swipeDown)
				controls.DOWN_P = true;
			if (SwipeUtil.swipeUp)
				controls.UP_P = true;
			if (SwipeUtil.swipeRight)
				controls.RIGHT_P = true;
		}
	}
}