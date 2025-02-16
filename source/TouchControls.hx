package;

import flixel.FlxG;

class TouchControls {
	private var startX:Float = 0;
	private var startY:Float = 0;
	private var startTime:Float = 0;
	private var isSwiping:Bool = false;

	public function new() {
		// Constructor if necessary
	}

	public function update(elapsed:Float):Null<String> {
		var swipeDirection:Null<String> = null;

		if (FlxG.mouse.pressed && !isSwiping) {
			startX = FlxG.mouse.x;
			startY = FlxG.mouse.y;
			startTime = elapsed;
			isSwiping = true;
		}

		// Detect swipe release.
		if (FlxG.mouse.released && isSwiping) {
			var endX:Float = FlxG.mouse.x;
			var endY:Float = FlxG.mouse.y;
			var endTime:Float = elapsed;

			var deltaX:Float = endX - startX;
			var deltaY:Float = endY - startY;

			var swipeDistance:Float = Math.sqrt(deltaX * deltaX + deltaY * deltaY);
			var swipeTime:Float = endTime - startTime;

			// Threshold definitions.
			var minSwipeDistance:Float = 50;
			var maxSwipeTime:Float = 0.5;

			// Check swipe conditions.
			if (swipeDistance >= minSwipeDistance && swipeTime <= maxSwipeTime) {
				swipeDirection = detectSwipeDirection(deltaX, deltaY);
			}

			// Reset swipe flag.
			isSwiping = false;

			return swipeDirection;
		}

		// Return null if no swipe is detected.
		return null;
	}

	private function detectSwipeDirection(deltaX:Float, deltaY:Float):String {
		if (Math.abs(deltaX) > Math.abs(deltaY)) {
			if (deltaX > 0) {
				return "right";
			} else {
				return "left";
			}
		} else {
			if (deltaY > 0) {
				return "down";
			} else {
				return "up";
			}
		}
	}
}
