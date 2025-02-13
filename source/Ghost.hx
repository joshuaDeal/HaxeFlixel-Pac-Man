package;

import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.math.FlxPoint;

class Ghost extends FlxSprite {
	public var direction:Constants.Direction = Constants.Direction.UP;
	public var newDirection:Constants.Direction = Constants.Direction.UP;
	public var isVertical:Bool = true;
	public var mode:Constants.GhostMode = Constants.GhostMode.CHASE;
	public var speed:Int = Constants.GHOST_SPEED;
	public var pathPoints:Array<FlxPoint> = null;
	public var lastX:Float;
	public var lastY:Float;

	public function new (x:Float = 0, y:Float = 0) {
		super(x, y);

		//Set dimensions of Ghost.
		this.setSize(Constants.GHOST_SIZE, Constants.GHOST_SIZE);
		//this.makeGraphic(Constants.GHOST_SIZE, Constants.GHOST_SIZE, FlxColor.RED);
		this.loadGraphic("assets/images/ghost.png", true, Constants.GHOST_SIZE, Constants.GHOST_SIZE);

		// Create animations.
		animation.add("blinky_left", [0, 1]);
		animation.add("blinky_right", [2, 3]);
		animation.add("blinky_up", [4, 5]);
		animation.add("blinky_down", [6, 7]);
		animation.add("pinky_left", [8, 9]);
		animation.add("pinky_right", [10, 11]);
		animation.add("pinky_up", [12, 13]);
		animation.add("pinky_down", [14, 15]);
		animation.add("inky_left", [16, 17]);
		animation.add("inky_right", [18, 19]);
		animation.add("inky_up", [20, 21]);
		animation.add("inky_down", [22, 23]);
		animation.add("clyde_left", [24, 25]);
		animation.add("clyde_right", [26, 27]);
		animation.add("clyde_up", [28, 29]);
		animation.add("clyde_down", [30, 31]);
		animation.add("flee_left", [32, 33]);
		animation.add("flee_right", [34, 35]);
		animation.add("flee_up", [36, 37]);
		animation.add("flee_down", [38, 39]);
	}

	public function moveGhost():Void {
		if (isVertical) {
			if (newDirection == Constants.Direction.UP || newDirection == Constants.Direction.DOWN) {
				direction = newDirection;
			}

			if (direction == Constants.Direction.UP) {
				this.y -= speed;
			} else if (direction == Constants.Direction.DOWN) {
				this.y += speed;
			}
		} else {
			if (newDirection == Constants.Direction.LEFT || newDirection == Constants.Direction.RIGHT) {
				direction = newDirection;
			}

			if (direction == Constants.Direction.LEFT) {
				this.x -= speed;
			} else if (direction == Constants.Direction.RIGHT) {
				this.x += speed;
			}
		}
	}

	public function changeDirection():Void {
		if (!isVertical && newDirection == Constants.Direction.UP || newDirection == Constants.Direction.DOWN) {
			direction = newDirection;
		} else if (isVertical && newDirection == Constants.Direction.LEFT || newDirection == Constants.Direction.RIGHT) {
			direction = newDirection;
		}

		isVertical = (direction == Constants.Direction.UP || direction == Constants.Direction.DOWN);
	}

	public function findDirection(targetX:Int, targetY:Int, possibleDirections:Array<Constants.Direction>):Constants.Direction {
		var oppositeDirection:Constants.Direction;

		// Find opposite direction
		switch (direction) {
			case Constants.Direction.LEFT: oppositeDirection = Constants.Direction.RIGHT;
			case Constants.Direction.RIGHT: oppositeDirection = Constants.Direction.LEFT;
			case Constants.Direction.UP: oppositeDirection = Constants.Direction.DOWN;
			case Constants.Direction.DOWN: oppositeDirection = Constants.Direction.UP;
		}

		// Filter out opposite direction.
		var validMoves = possibleDirections.filter(d -> d != oppositeDirection);

		// Calculate deltas.
		var deltaX:Float = targetX - x;
		var deltaY:Float = targetY - y;

		// Find preferred direction.
		var preferredDirection:Constants.Direction = null;

		if (Math.abs(deltaX) > Math.abs(deltaY)) {
			// Prefer horizontal movement.
			if (deltaX > 0 && validMoves.indexOf(Constants.Direction.RIGHT) >= 0) {
				preferredDirection = Constants.Direction.RIGHT;
			} else if (deltaX < 0 && validMoves.indexOf(Constants.Direction.LEFT) >= 0) {
				preferredDirection = Constants.Direction.LEFT;
			}
		} else {
			// Prefer vertical movement.
			if (deltaY > 0 && validMoves.indexOf(Constants.Direction.DOWN) >= 0) {
				preferredDirection = Constants.Direction.DOWN;
			} else if (deltaY < 0 && validMoves.indexOf(Constants.Direction.UP) >= 0) {
				preferredDirection = Constants.Direction.UP;
			}
		}

		if (preferredDirection != null) {
			return preferredDirection;
		}

		// If no preferred direction found, return arbitrary valid direction.
		return validMoves.length > 0 ? validMoves[0] : null;
	}
}
