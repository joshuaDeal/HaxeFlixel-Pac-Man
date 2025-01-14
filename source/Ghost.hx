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

	public function new (x:Float = 0, y:Float = 0) {
		super(x, y);

		//Set dimensions of Ghost.
		this.setSize(Constants.GHOST_SIZE, Constants.GHOST_SIZE);
		this.makeGraphic(Constants.GHOST_SIZE, Constants.GHOST_SIZE, FlxColor.RED);
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
