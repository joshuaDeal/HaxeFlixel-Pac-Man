package;

import flixel.group.FlxGroup;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.text.FlxText;

class GameOverScreen extends FlxGroup {
	private var background:FlxSprite;
	private var gameOverText:FlxText;
	private var subText:FlxText;

	public function new():Void {
		super();

		// Create background.
		background = new FlxSprite(0,0);
		background.makeGraphic(FlxG.width, FlxG.height, FlxColor.fromRGB(0, 0, 0, 200));
		add(background);

		// Create text.
		gameOverText = new FlxText(0, FlxG.height / 2 - 50, FlxG.width, "Game Over");
		gameOverText.setFormat(null, 64, FlxColor.RED, "center");
		add(gameOverText);
		subText = new FlxText(0, FlxG.height / 2 + 30, FlxG.width, "Press enter or tap to restart.\nPress esc to return to main menu.");
		subText.setFormat(null, 32, FlxColor.RED, "center");
		add(subText);
	}

	public function show():Void {
		this.visible = true;
	}

	public function hide():Void {
		this.visible = false;
	}
}
