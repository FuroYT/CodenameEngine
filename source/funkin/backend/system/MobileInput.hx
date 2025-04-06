package funkin.backend.system;

import flixel.input.touch.FlxTouchManager;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import funkin.backend.system.Controls;
import funkin.options.PlayerSettings;

class MobileInput {
	public static function init() {
		#if mobile
		FlxG.signals.preUpdate.add(handleMobileInput);
		#end
	}

	static var controls(get, never):Controls;
	
	static inline function get_controls():Controls
		return PlayerSettings.solo.controls;

	static var touchesTime:Map<Int, Float> = new Map<Int, Float>();
	static var touchesStartPos:Map<Int, FlxPoint> = new Map<Int, FlxPoint>();
	static var touchesPos:Map<Int, FlxPoint> = new Map<Int, FlxPoint>();
	
	static function handleMobileInput() @:privateAccess {
		var touchManager:FlxTouchManager = FlxG.touches;
		for (touch in touchManager.list)
		{
			if (touch.justPressed)
			{
				touchesTime.set(touch.touchPointID, 0);
				touchesStartPos.set(touch.touchPointID, FlxPoint.get(touch.flashPoint.x, touch.flashPoint.y));
				touchesPos.set(touch.touchPointID, FlxPoint.get(touch.flashPoint.x, touch.flashPoint.y));
			} else if (touch.pressed)
			{
				touchesTime.set(touch.touchPointID, touchesTime.get(touch.touchPointID) + FlxG.elapsed);
				touchesPos.set(touch.touchPointID, FlxPoint.get(touch.flashPoint.x, touch.flashPoint.y));
			} else if (touch.justReleased)
			{
				touchesPos.set(touch.touchPointID, FlxPoint.get(touch.flashPoint.x, touch.flashPoint.y));

				var timeHeld:Float = touchesTime.get(touch.touchPointID);
				var startPos:FlxPoint = touchesStartPos.get(touch.touchPointID);
				var endPos:FlxPoint = touchesPos.get(touch.touchPointID);

				var distance = 0; //FlxMath.vectorLength(startPos.x - endPos.x, startPos.y - endPos.y);
				var distanceOfScreenPercentage = distance / FlxG.width;

				touchesTime.remove(touch.touchPointID);
				touchesPos.remove(touch.touchPointID);
				touchesStartPos.remove(touch.touchPointID);

				if (timeHeld > 0.5) // 500ms
				{
					if (distanceOfScreenPercentage > 0.05)
					{
						if (distanceOfScreenPercentage > 0.1)
						{
							if (Math.abs(startPos.x - endPos.x) > Math.abs(startPos.y - endPos.y)) {
								if (startPos.x < endPos.x)
									controls.RIGHT_P = controls.RIGHT_R = true;
								else
									controls.LEFT_P = controls.LEFT_R = true;
							} else {
								if (startPos.y < endPos.y)
									controls.DOWN_P = controls.DOWN_R = true;
								else
									controls.UP_P = controls.UP_R = true;
							}
						}
					}
					else
					{
						controls.ACCEPT = true;
					}
				}
				else
				{
					controls.ACCEPT = true;
				}
			}
		}
	}
}