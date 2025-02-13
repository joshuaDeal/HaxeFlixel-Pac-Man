package;

import flixel.FlxSprite;
import flixel.util.FlxColor;

class Player extends FlxSprite {
	public var direction:Constants.Direction = Constants.Direction.LEFT;
	public var newDirection:Constants.Direction = Constants.Direction.LEFT;
	public var isVertical:Bool = false;

	public function new (x:Float = 0, y:Float = 0) {
		super(x, y);

		//Set dimensions of player.
		this.setSize(Constants.PLAYER_SIZE, Constants.PLAYER_SIZE);
		this.loadGraphic("assets/images/player.png", true, Constants.PLAYER_SIZE, Constants.PLAYER_SIZE);

		animation.add("left", [0, 1, 2, 1]);
		animation.add("right", [3, 4, 5, 4]);
		animation.add("up", [6, 7, 8, 7]);
		animation.add("down", [9, 10, 11, 10]);
	}

	public function movePlayer():Void {
		if (isVertical) {
			if (newDirection == Constants.Direction.UP || newDirection == Constants.Direction.DOWN) {
				direction = newDirection;
			}

			if (direction == Constants.Direction.UP) {
				this.y -= Constants.PLAYER_SPEED;
			} else if (direction == Constants.Direction.DOWN) {
				this.y += Constants.PLAYER_SPEED;
			}
		} else {
			if (newDirection == Constants.Direction.LEFT || newDirection == Constants.Direction.RIGHT) {
				direction = newDirection;
			}

			if (direction == Constants.Direction.LEFT) {
				this.x -= Constants.PLAYER_SPEED;
			} else if (direction == Constants.Direction.RIGHT) {
				this.x += Constants.PLAYER_SPEED;
			}
		}
	}

	public function changeDirection(validMoves:Array<Constants.Direction> = null):Void {
		// Set default value if no validMoves are provided.
		if (validMoves == null) {
			validMoves = [Constants.Direction.LEFT, Constants.Direction.RIGHT, Constants.Direction.UP, Constants.Direction.DOWN];
		}

		if (validMoves.indexOf(newDirection) != -1) {
			if (!isVertical && newDirection == Constants.Direction.UP || newDirection == Constants.Direction.DOWN) {
				direction = newDirection;
			} else if (isVertical && newDirection == Constants.Direction.LEFT || newDirection == Constants.Direction.RIGHT) {
				direction = newDirection;
			}

			isVertical = (direction == Constants.Direction.UP || direction == Constants.Direction.DOWN);
		}
	}
}
