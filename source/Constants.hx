package;

enum Direction {
	UP;
	DOWN;
	LEFT;
	RIGHT;
}

enum GhostMode {
	CHASE;
	SCATTER;
	FLEE;
	ATE;
	PEN;
	EXIT_PEN;
}

enum FruitOption {
	CHERRY;
	STRAWBERRY;
	ORANGE;
	APPLE;
	MELON;
	GALAXIAN;
	BELL;
	KEY;
}

class Constants {
	public static final PLAYER_SPEED:Int = 16;
	public static final PLAYER_SIZE:Int = 64;
	public static final INTERSECTION_SIZE:Int = 64;
	public static final GHOST_SPEED:Int = 16;
	public static final GHOST_SIZE:Int = 64;
	public static final DOT_VALUE:Int = 10;
	public static final BIG_DOT_VALUE:Int = 50;
	public static final LIVES:Int = 3;
	public static final TILEMAP_WIDTH:Int = 1792;
	public static final TILEMAP_HEIGHT:Int = 2304;
	public static final FLEE_TIME:Float = 5.0;
	public static final GHOST_POINTS:Int = 200;
	public static final EXTRA_LIFE_SCORE:Int = 10000;
}
