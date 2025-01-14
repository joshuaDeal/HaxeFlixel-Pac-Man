package;

import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;

class BigDot extends FlxSprite {
	private static final SIZE = 8;

	public function new(x:Float = 0, y:Float = 0):Void {
		super(x,y);

		this.setSize(SIZE, SIZE);
		this.makeGraphic(SIZE, SIZE, FlxColor.PINK);
	}

	override public function kill():Void {
		alive = false;
		FlxTween.tween(this, {alpha: 0, y: y -16}, 0.33, {ease: FlxEase.circOut, onComplete: finishKill});
	}

	private function finishKill(_):Void {
		exists = false;
	}
}
