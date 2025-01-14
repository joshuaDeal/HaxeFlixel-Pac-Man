package;

import flixel.FlxGame;
import openfl.display.Sprite;

class Main extends Sprite
{
	public function new()
	{
		super();
		addChild(new FlxGame(Constants.TILEMAP_WIDTH, Constants.TILEMAP_HEIGHT, MenuState));
	}
}
