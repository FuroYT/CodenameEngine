package modchart;

class Config {
	/**
	 * Set to false to disable 3d cameras (it also can improve performance)
	 */
	public static var CAMERA3D_ENABLED:Bool = true;

	/**
	 * Rotation Axis Order
	 * 
	 * `Z_Y_X` by default.
	 */
	public static var ROTATION_ORDER:RotationOrder = Z_Y_X;

	/**
	 * Shows the sustains before the strums
	 * 
	 * `false` by default.
	 */
	public static var HOLDS_BEHIND_STRUM:Bool = false;
}