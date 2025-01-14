package;

import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;

class Fruit extends FlxSprite {
	private static final SIZE = 16;
	public var value = 0;

	public function new(x:Float = 0, y:Float = 0):Void {
		super(x,y);

		this.setSize(SIZE, SIZE);
		this.makeGraphic(SIZE, SIZE, FlxColor.PURPLE);
	}

	public function hide():Void {
		alive = false;
		FlxTween.tween(this, {alpha: 0, y: y - 16}, 0.33, {ease: FlxEase.circOut, onComplete: finishHide});
	}

	public function finishHide(_):Void {
		return;
	}

	public function unhide():Void {
		alive = true;
		alpha = 1;
	}

	public function setFruit(fruit:Constants.FruitOption):Void {
		switch (fruit) {
			case Constants.FruitOption.CHERRY:
				this.makeGraphic(SIZE, SIZE, FlxColor.RED);
				value = 100;
			case Constants.FruitOption.STRAWBERRY:
				this.makeGraphic(SIZE, SIZE, FlxColor.PINK);
				value = 300;
			case Constants.FruitOption.ORANGE:
				this.makeGraphic(SIZE, SIZE, FlxColor.ORANGE);
				value = 500;
			case Constants.FruitOption.APPLE:
				this.makeGraphic(SIZE, SIZE, FlxColor.RED);
				value = 700;
			case Constants.FruitOption.MELON:
				this.makeGraphic(SIZE, SIZE, FlxColor.GREEN);
				value = 1000;
			case Constants.FruitOption.GALAXIAN:
				this.makeGraphic(SIZE, SIZE, FlxColor.YELLOW);
				value = 2000;
			case Constants.FruitOption.BELL:
				this.makeGraphic(SIZE, SIZE, FlxColor.YELLOW);
				value = 3000;
			case Constants.FruitOption.KEY:
				this.makeGraphic(SIZE, SIZE, FlxColor.BLUE);
				value = 5000;
		}
	}
}
