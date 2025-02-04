package;

import flixel.FlxState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.FlxG;

class MenuState extends FlxState {
	var startText:FlxText;

	override public function create() {
		super.create();

		// Create text.
		startText = new FlxText(0, FlxG.height / 2 - 50 , FlxG.width, "Press enter key.");
		startText.setFormat(null, 64, FlxColor.WHITE, "center");
		add(startText);
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);

		if (FlxG.keys.pressed.ENTER) {
			startGame();
		}
	}

	public function startGame() {
		FlxG.switchState(new PlayState());
	}
}
