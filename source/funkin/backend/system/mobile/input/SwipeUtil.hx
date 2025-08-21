package funkin.backend.system.mobile.input;

class SwipeUtil
{
	public static var swipeLeft(get, null):Bool;
	public static var swipeDown(get, null):Bool;
	public static var swipeUp(get, null):Bool;
	public static var swipeRight(get, null):Bool;
	public static var swipeAny(get, null):Bool;

	public static function get_swipeDown(): Bool
	{
		#if FLX_POINTER_INPUT
		for (swipe in FlxG.swipes)
			if (swipe.degrees > -135 && swipe.degrees < -45 && swipe.distance > 20) return true; //prevents only 1 swipe being registered
		#end

		return false;
	}

	public static function get_swipeLeft(): Bool
	{
		#if FLX_POINTER_INPUT
		for (swipe in FlxG.swipes)
			if (swipe.degrees > -45 && swipe.degrees < 45 && swipe.distance > 20) return true;
		#end

		return false;
	}

	public static function get_swipeRight(): Bool
	{
		#if FLX_POINTER_INPUT
		for (swipe in FlxG.swipes)
			if ((swipe.degrees > 135 || swipe.degrees < -135) && swipe.distance > 20) return true;
		#end

		return false;
	}

	public static function get_swipeUp(): Bool
	{
		#if FLX_POINTER_INPUT
		for (swipe in FlxG.swipes)
			if (swipe.degrees > 45 && swipe.degrees < 135 && swipe.distance > 20) return true;
		#end

		return false;
	}

	public static function get_swipeAny(): Bool
		return swipeDown || swipeLeft || swipeRight || swipeUp;
}