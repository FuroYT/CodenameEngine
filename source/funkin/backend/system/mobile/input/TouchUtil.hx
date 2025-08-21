package funkin.backend.system.mobile.input;

import flixel.FlxBasic;
import flixel.FlxObject;
import flixel.input.touch.FlxTouch;
import flixel.math.FlxPoint;

class TouchUtil
{
  public static var pressed(get, null):Bool;
  public static var justPressed(get, null):Bool;
  public static var justReleased(get, null):Bool;
  public static var touch(get, null):FlxTouch;

  public static function overlaps(object: FlxBasic, ?camera: FlxCamera): Bool
  {
    if (object == null) return false;

    #if FLX_TOUCH
    for (touch in FlxG.touches.list)
    {
		var overlapsCamera = camera;
		if (camera == null)
			overlapsCamera = object.camera;
      	if (touch.overlaps(object, overlapsCamera)) return true;
    }
    #end

    return false;
  }

  public static function overlapsComplex(object: FlxObject, ?camera: FlxCamera): Bool
  {
    if (object == null) return false;

    #if FLX_TOUCH
    if (camera == null)
    {
      for (camera in object.cameras)
        for (touch in FlxG.touches.list)
          @:privateAccess if (object.overlapsPoint(touch.getWorldPosition(camera, object._point), true, camera)) return true;
    }
    else
      @:privateAccess if (object.overlapsPoint(touch.getWorldPosition(camera, object._point), true, camera)) return true;
    #end

    return false;
  }

  public static function overlapsComplexPoint(object: FlxObject, point: FlxPoint, ?inScreenSpace: Bool = false, ?camera: FlxCamera): Bool
  {
    if (object == null || point == null) return false;

    #if FLX_TOUCH
    if (camera == null)
    {
      for (camera in object.cameras)
        @:privateAccess if (object.overlapsPoint(point, inScreenSpace, camera))
        {
          point.putWeak();
          return true;
        }
    }
    else
      @:privateAccess if (object.overlapsPoint(point, inScreenSpace, camera))
      {
        point.putWeak();
        return true;
      }
    #end

    point.putWeak();
    return false;
  }

  private static function get_pressed():Bool
  {
    #if FLX_TOUCH
    for (touch in FlxG.touches.list)
      if (touch.pressed)
		return true;
    #end

    return false;
  }

  private static function get_justPressed():Bool
  {
    #if FLX_TOUCH
    for (touch in FlxG.touches.list)
      if (touch.justPressed)
		return true;
    #end

    return false;
  }

  private static function get_justReleased():Bool
  {
    #if FLX_TOUCH
    for (touch in FlxG.touches.list)
      if (touch.justReleased)
		return true;
    #end

    return false;
  }

  private static function get_touch():FlxTouch
  {
    #if FLX_TOUCH
    for (touch in FlxG.touches.list)
      if (touch != null)
		return touch;

    return FlxG.touches.getFirst();
    #else
    return null;
    #end
  }
}