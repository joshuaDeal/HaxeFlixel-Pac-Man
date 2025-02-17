package;

import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import haxe.Timer;

class BigDot extends FlxSprite {
	private static final SIZE = 32;

	public function new(x:Float = 0, y:Float = 0):Void {
		super(x,y);

		this.setSize(SIZE, SIZE);
		this.loadGraphic("assets/images/bigdot.png", true, SIZE, SIZE);

		this.startBounce();
	}

	override public function kill():Void {
		alive = false;
		FlxTween.tween(this, {alpha: 0, y: y -64}, 0.33, {ease: FlxEase.circOut, onComplete: finishKill});
	}

	private function finishKill(_):Void {
		exists = false;
	}

	public function startBounce():Void {
		var delay:Int = Std.int((this.x / 16) * Constants.BOUNCE_OFFSET);
		Timer.delay(bounce, delay);
	}

	// Starts the bounce by making the dot move to the highest posistion in the bounce loop.
	private function bounce():Void {
		FlxTween.tween(this, {y: y - (Constants.BOUNCE_DISPLACEMENT / 2)}, 1.0, {ease: FlxEase.quadInOut, onComplete: function(_) {downBounce();}});
	}

	// Dot moves to lowest posistion in loop and then upBounce() is called.
	private function downBounce():Void {
		FlxTween.tween(this, {y: y + Constants.BOUNCE_DISPLACEMENT}, 1.0, {ease: FlxEase.quadInOut, onComplete: function(_) {upBounce();}});
	}

	// Dot moves to highest posistion in loop and then downBounce is called.
	private function upBounce():Void {
		FlxTween.tween(this, {y: y - Constants.BOUNCE_DISPLACEMENT}, 1.0, {ease: FlxEase.quadInOut, onComplete: function(_) {downBounce();}});
	}
}
