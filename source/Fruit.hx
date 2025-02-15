package;

import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;

class Fruit extends FlxSprite {
	private static final SIZE = 64;
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
				this.loadGraphic("assets/images/fruit001.png", true, SIZE, SIZE);
				value = 100;
			case Constants.FruitOption.STRAWBERRY:
				this.loadGraphic("assets/images/fruit002.png", true, SIZE, SIZE);
				value = 300;
			case Constants.FruitOption.ORANGE:
				this.loadGraphic("assets/images/fruit003.png", true, SIZE, SIZE);
				value = 500;
			case Constants.FruitOption.APPLE:
				this.loadGraphic("assets/images/fruit004.png", true, SIZE, SIZE);
				value = 700;
			case Constants.FruitOption.MELON:
				this.loadGraphic("assets/images/fruit005.png", true, SIZE, SIZE);
				value = 1000;
			case Constants.FruitOption.GALAXIAN:
				this.loadGraphic("assets/images/fruit006.png", true, SIZE, SIZE);
				value = 2000;
			case Constants.FruitOption.BELL:
				this.loadGraphic("assets/images/fruit007.png", true, SIZE, SIZE);
				value = 3000;
			case Constants.FruitOption.KEY:
				this.loadGraphic("assets/images/fruit008.png", true, SIZE, SIZE);
				value = 5000;
		}
	}
}
