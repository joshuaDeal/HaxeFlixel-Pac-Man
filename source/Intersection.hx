package;

import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.tile.FlxTilemap;

class Intersection extends FlxSprite {
	public function new(x:Float = 0, y:Float = 0) {
		super(x, y);

		this.setSize(Constants.INTERSECTION_SIZE, Constants.INTERSECTION_SIZE);
		this.makeGraphic(Constants.INTERSECTION_SIZE, Constants.INTERSECTION_SIZE, FlxColor.PINK);
		this.alpha = 0;
	}

	public function getPossibleDirections(walls:FlxTilemap):Array<Constants.Direction> {
		var directions = [];

		// Find center point.
		var centerX = this.x + this.width / 2;
		var centerY = this.y + this.height / 2;

		// Convert pixel coordinate to tile coordinate
		var tileX = Std.int(centerX / Constants.INTERSECTION_SIZE);
		var tileY = Std.int(centerY / Constants.INTERSECTION_SIZE);

		// Check for up.
		if (walls.getTileIndex(tileX, tileY - 1) == 0) {
			directions.push(Constants.Direction.UP);
		}

		// Check for down.
		if (walls.getTileIndex(tileX, tileY + 1) == 0) {
			directions.push(Constants.Direction.DOWN);
		}

		// Check for left.
		if (walls.getTileIndex(tileX - 1, tileY) == 0) {
			directions.push(Constants.Direction.LEFT);
		}

		// Check for right.
		if (walls.getTileIndex(tileX + 1, tileY) == 0) {
			directions.push(Constants.Direction.RIGHT);
		}
		return directions;
	}
}
