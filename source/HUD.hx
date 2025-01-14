package;

import flixel.FlxG;
import flixel.text.FlxText;

class HUD {
	private var score:Int = 0;
	private var scoreText:FlxText;
	private var lives:Int = 3;
	private var livesText:FlxText;

	public function new():Void {
		// Create score text object.
		scoreText = new FlxText(40, 10, 0, Std.string(score), 10);
		scoreText.setFormat(null, 32, 0xFFFFFF, "left");

		// Create lives text objects.
		livesText = new FlxText(300, 10, 0, Std.string("Lives: " + lives), 10);
		livesText.setFormat(null, 32, 0xFFFFFF, "left");
	}

	public function update():Void {
		scoreText.text = Std.string(score);
		livesText.text = Std.string("Lives: " + lives);
	}

	public function draw():Void {
		scoreText.draw();
		livesText.draw();
	}

	public function addToScore(num:Int):Void {
		score += num;
	}

	public function removeLife():Void {
		lives--;
	}

	public function addLife():Void {
		lives++;
	}

	public function resetScore():Void {
		score = 0;
	}

	public function resetLives():Void {
		lives = Constants.LIVES;
	}
}
