package;

import flixel.FlxState;
import flixel.FlxG;
import flixel.addons.editors.ogmo.FlxOgmo3Loader;
import flixel.tile.FlxTilemap;
import flixel.group.FlxGroup;
import flixel.util.FlxColor;
import haxe.Timer;
import flixel.FlxCamera;
import flixel.math.FlxPoint;
import flixel.path.FlxPathfinder;
import flixel.path.FlxPath;
import flixel.sound.FlxSound;

class PlayState extends FlxState {
	private var player:Player;
	private var map:FlxOgmo3Loader;
	private var walls:FlxTilemap;
	private var intersections:FlxTypedGroup<Intersection>;
	private var dots:FlxTypedGroup<Dot>;
	private var bigDots:FlxTypedGroup<BigDot>;
	private var blinky:Ghost;
	private var pinky:Ghost;
	private var inky:Ghost;
	private var clyde:Ghost;
	private var score:Int = 0;
	private var lives:Int = Constants.LIVES;
	private var pathfinder = new BigMoverPathfinder(1, 1, NONE);
	private var diagonalPolicy:FlxTilemapDiagonalPolicy = NONE;
	private var simplify = FlxPathSimplifier.LINE;
	private var dotCount:Int = 0;
	private var dotGoal:Int = 0;
	private var hud:HUD;
	private var stage:Int = 1;
	private var ghostFleeDuration:Float = Constants.FLEE_TIME;
	private var ghostFleeTime:Map<Ghost, Float>;
	private var ghostPenTime:Map<Ghost, Float>;
	private var ghostModeTime:Int;
	private var fruitTime:Int;
	private var isGameFrozen:Bool = false;
	private var dotSound:FlxSound;
	private var fruitSound:FlxSound;
	private var bigDotSound:FlxSound;
	private var ghostAteSound:FlxSound;
	private var playerAteSound:FlxSound;
	private var ghostRoamSound:FlxSound;
	private var ghostFleeSound:FlxSound;
	private var ghostEyeSound:FlxSound;
	private var extraLifeSound:FlxSound;
	private var chime:FlxSound;
	private var gameOverChime:FlxSound;
	private var gameOverScreen:GameOverScreen;
	private var ghostsEatenInFlee:Int = 0;
	private var gameOver:Bool = false;
	private var ghostSpeed:Int = Constants.GHOST_SPEED;
	private var extraLifeScore:Int = 0;
	private var fruit:Fruit;
	private var lastX:Float;
	private var lastY:Float;

	override public function create() {
		super.create();

		// Create and manage tilemap.
		map = new FlxOgmo3Loader("assets/data/pacman.ogmo", "assets/data/maze.json");
		walls = map.loadTilemap("assets/images/tiles.png", "walls");
		walls.follow();
		walls.setTileProperties(1, NONE);
		walls.setTileProperties(2, ANY);
		add(walls);

		// Create player
		player = new Player();
		add(player);

		// Create intersections
		intersections = new FlxTypedGroup<Intersection>();
		add(intersections);

		// Create dots.
		dots = new FlxTypedGroup<Dot>();
		add(dots);

		// Create big dots.
		bigDots = new FlxTypedGroup<BigDot>();
		add(bigDots);

		// Create fruit.
		fruit = new Fruit();

		// Create ghosts.
		blinky = new Ghost();
		blinky.path = new FlxPath();
		blinky.path.immovable = false;
		add(blinky);
		pinky = new Ghost();
		pinky.path = new FlxPath();
		pinky.path.immovable = false;
		add(pinky);
		inky = new Ghost();
		inky.path = new FlxPath();
		inky.path.immovable = false;
		add(inky);
		clyde = new Ghost();
		clyde.path = new FlxPath();
		clyde.path.immovable = false;
		add(clyde);

		// Create timers.
		// Flee timers.
		ghostFleeTime = new Map<Ghost, Float>();
		ghostFleeTime.set(blinky, 0.0);
		ghostFleeTime.set(pinky, 0.0);
		ghostFleeTime.set(inky, 0.0);
		ghostFleeTime.set(clyde, 0.0);
		// Pen timers.
		ghostPenTime = new Map<Ghost, Float>();
		ghostPenTime.set(blinky, 0.0);
		ghostPenTime.set(pinky, 0.0);
		ghostPenTime.set(inky, 0.0);
		ghostPenTime.set(clyde, 0.0);
		// Mode timer.
		ghostModeTime = 0;
		// Fruit timer.
		fruitTime = 0;

		// Create HUD.
		hud = new HUD();

		// Create sounds.
		dotSound = FlxG.sound.load("assets/sounds/dot.ogg");
		bigDotSound = FlxG.sound.load("assets/sounds/big_dot.ogg");
		fruitSound = FlxG.sound.load("assets/sounds/big_dot.ogg");
		ghostAteSound = FlxG.sound.load("assets/sounds/ghost_ate.ogg");
		playerAteSound = FlxG.sound.load("assets/sounds/player_ate.ogg");
		ghostRoamSound = FlxG.sound.load("assets/sounds/ghost_roam.ogg");
		ghostFleeSound = FlxG.sound.load("assets/sounds/ghost_flee.ogg");
		ghostEyeSound = FlxG.sound.load("assets/sounds/ghost_eyes.ogg");
		chime = FlxG.sound.load("assets/sounds/chime.ogg");
		gameOverChime = FlxG.sound.load("assets/sounds/game_over_chime.ogg");
		extraLifeSound = FlxG.sound.load("assets/sounds/extra_life.ogg");

		// Add entities to map. **This should be called after creating and adding each entity!**
		map.loadEntities(placeEntities, "entities");

		// Reset the dot goal and count.
		dotCount = 0;
		dotGoal = dots.length + bigDots.length;

		// Reset the ghosts.
		resetGhost(blinky);
		resetGhost(pinky);
		resetGhost(inky);
		resetGhost(clyde);

		// Create game over screen.
		gameOverScreen = new GameOverScreen();
		gameOverScreen.visible = false;
		add(gameOverScreen);

		//Play chime for stage 1.
		chime.play(false);

		// Freeze game for stage 1.
		freezeGame(900);
	}

	override public function update(elapsed:Float) {
		// Only update game when it is not frozen.
		if (!isGameFrozen) {
			super.update(elapsed);

			//trace("Dots remaining: " + dotCount);

			// Player controls.
			if (FlxG.keys.pressed.W || FlxG.keys.pressed.UP) {
				player.newDirection = Constants.Direction.UP;
			} else if (FlxG.keys.pressed.S || FlxG.keys.pressed.DOWN) {
				player.newDirection = Constants.Direction.DOWN;
			} else if (FlxG.keys.pressed.A || FlxG.keys.pressed.LEFT) {
				player.newDirection = Constants.Direction.LEFT;
			} else if (FlxG.keys.pressed.D || FlxG.keys.pressed.RIGHT) {
				player.newDirection = Constants.Direction.RIGHT;
			}

			//Move player.
			player.movePlayer();

			// Allow collisions between player and walls.
			FlxG.collide(player, walls);

			// Check if player is in intersection.
			for (intersection in intersections.members) {
				if (intersection.x == player.x && intersection.y == player.y) {
					player.changeDirection(intersection.getPossibleDirections(walls));
					break;
				}
			}

			// Check if player is touching a dot.
			FlxG.overlap(player, dots, playerTouchDot);
			FlxG.overlap(player, bigDots, playerTouchBigDot);

			// Animate player.
			if (lastX != player.x || lastY != player.y) {
				switch(player.direction) {
					case Constants.Direction.LEFT:
						player.animation.play("left");
					case Constants.Direction.RIGHT:
						player.animation.play("right");
					case Constants.Direction.UP:
						player.animation.play("up");
					case Constants.Direction.DOWN:
						player.animation.play("down");
				}
			} else {
				player.animation.pause();
			}

			lastX = player.x;
			lastY = player.y;

			// Manage fruit.
			manageFruit(elapsed);

			// Give player an extra life.
			if (extraLifeScore >= Constants.EXTRA_LIFE_SCORE) {
				lives++;
				hud.addLife();
				extraLifeScore = 0;
				extraLifeSound.play(false);
			}

			// Manage ghosts.
			manageGhost(blinky, elapsed);
			manageGhost(pinky, elapsed);
			manageGhost(inky, elapsed);
			manageGhost(clyde, elapsed);

			ghostSounds();

			// Update ghost mode timer.
			ghostModeTime += Std.int(elapsed * 60);

			// Switch ghost modes.
			if (ghostModeTime >= 240) {
				toggleChaseScatter(blinky);
				toggleChaseScatter(pinky);
				toggleChaseScatter(inky);
				toggleChaseScatter(clyde);

				ghostModeTime = 0;
			}

			// Reset ghosts eaten in flee.
			if (blinky.mode != Constants.GhostMode.FLEE && pinky.mode != Constants.GhostMode.FLEE && inky.mode != Constants.GhostMode.FLEE && clyde.mode != Constants.GhostMode.FLEE) {
				ghostsEatenInFlee = 0;
			}

			// Teleport player if player exits stage left or right.
			if (player.x <= -64) {
				player.x = 1792;
			} else if (player.x >= 1792) {
				player.x = -64;
			}

			// Basic win condition.
			if (dotCount == dotGoal) {
				resetStage();
			}

			// Game over
			if (gameOver) {
				if (FlxG.keys.pressed.ENTER) {
					// Restart game.
					restartGame();
					gameOverScreen.hide();
				} else if (FlxG.keys.pressed.ESCAPE) {
					// Switch to menu state.
					FlxG.switchState(new MenuState());
				}
			}

			// Update HUD.
			hud.update();
		}
	}

	override public function draw():Void {
		super.draw();
		hud.draw();
	}

	public function manageFruit(elapsed:Float):Void {
		if (dotCount ==  70) {
			// Create fruit.
			fruit.unhide();
			add(fruit);
			fruit.x = 868;
			fruit.y = 1280;

			switch (stage) {
				case 1: fruit.setFruit(Constants.FruitOption.CHERRY);
				case 2: fruit.setFruit(Constants.FruitOption.STRAWBERRY);
				case 3: fruit.setFruit(Constants.FruitOption.ORANGE);
				case 4: fruit.setFruit(Constants.FruitOption.APPLE);
				case 5: fruit.setFruit(Constants.FruitOption.MELON);
				case 6: fruit.setFruit(Constants.FruitOption.GALAXIAN);
				case 7: fruit.setFruit(Constants.FruitOption.BELL);
				default: fruit.setFruit(Constants.FruitOption.KEY);
			}

		} else if (dotCount == 170 || fruitTime >= 1000) {
			// Remove fruit.
			resetFruit();
		}

		// Fruit timer.
		if (fruit.alive) {
			fruitTime += Std.int(elapsed * 60);
		}

		// Check if player is touching fruit.
		if(FlxG.overlap(player, fruit)) {
			playerTouchFruit();
		}
	}

	public function restartGame():Void {
		stage = 0;
		lives = Constants.LIVES;
		score = 0;
		extraLifeScore = 0;
		ghostModeTime = 0;
		ghostSpeed = Constants.GHOST_SPEED;
		ghostFleeDuration = Constants.FLEE_TIME;
		hud.resetScore();
		hud.resetLives();
		add(player);
		resetStage();

		//Play chime for stage 1.
		chime.play(false);

		/*
		// Temporary fix for bug with dot count. Offset dot count to accommodate for miscalculation.
		// I think this is fixed but I need to test the game more to know for sure.
		if ((dots.length + bigDots.length) > dotGoal) {
			dotCount = dots.length - dotGoal;
		}

		trace("dotCount: " + dotCount);
		trace("dotGoal: " + dotGoal);
		*/
	}

	private function freezeGame(duration:Int):Void {
		isGameFrozen = true;

		Timer.delay(unfreezeGame, duration);
	}

	private function unfreezeGame():Void {
		isGameFrozen = false;
	}

	private function resetStage():Void {
		//freeze game
		freezeGame(900);

		// Increase stage.
		stage++;

		trace("stage " + stage);

		// Stage specific settings.
		if (stage == 2) {
			ghostFleeDuration = Constants.FLEE_TIME * (4 / 5);
		} else if (stage == 3) {
			ghostSpeed++;
		} else if (stage == 4) {
			ghostFleeDuration = Constants.FLEE_TIME * (3 / 5);
		} else if (stage == 5) {
			ghostSpeed++;
		} else if (stage == 6) {
			ghostFleeDuration = Constants.FLEE_TIME * (2 / 5);
		} else if (stage == 7) {
			ghostSpeed++;
		} else if (stage == 8) {
			ghostFleeDuration = Constants.FLEE_TIME * (1 / 5);
		} else if (stage == 10) {
			ghostFleeDuration = 0;
		}

		// Reset dots.
		resetDots();

		// Reset ghosts.
		resetGhost(blinky);
		resetGhost(pinky);
		resetGhost(inky);
		resetGhost(clyde);

		// Reset player.
		resetPlayer();

		// Reset fruit.
		resetFruit();
	}

	private function resetFruit() {
		// Reset fruit.
		fruit.x = -1000;
		fruit.y = -1000;
		remove(fruit);
		fruitTime = 0;
	}

	private function playerTouchFruit() {
		if (fruit.alive) {
			fruit.hide();
			fruitSound.play(false);
			score += fruit.value;
			extraLifeScore += fruit.value;
			hud.addToScore(fruit.value);
		}
	}

	private function resetDots() {
		// Clear existing dots.
		dots.clear();
		bigDots.clear();
		dotCount = 0;
		dotGoal = 0;

		// Call placeEntities to re-add dots.
		map.loadEntities(placeEntities, "entities");

		dotGoal = dots.length + bigDots.length;
	}

	private function manageGhost(ghost:Ghost, elapsed:Float):Void {
		// Move ghost.
		if (ghost.mode == Constants.GhostMode.PEN || ghost.mode == Constants.GhostMode.FLEE) {
			ghost.moveGhost();
		} else if (ghost.mode == Constants.GhostMode.CHASE || ghost.mode == Constants.GhostMode.SCATTER) {
			ghost.moveGhost();
		} else if (ghost.mode == Constants.GhostMode.EXIT_PEN) {
			ghostFollowPath(ghost, 864, 896, elapsed);
		} else if (ghost.mode == Constants.GhostMode.ATE) {
			if (ghost == blinky)
				ghostFollowPath(ghost, 864, 896, elapsed);
			else if (ghost == pinky)
				ghostFollowPath(ghost, 736, 1024, elapsed);
			else if (ghost == inky)
				ghostFollowPath(ghost, 864, 1156, elapsed);
			else if (ghost == clyde)
				ghostFollowPath(ghost, 992, 1024, elapsed);
		}

		// Allow collisions between ghost and walls.
		FlxG.collide(ghost, walls);

		// Slow ghosts down if they are in exit tunnle.
		if ((ghost.x < 384 && ghost.y == 1088) || (ghost.x > 1344 && ghost.y == 1088)) {
			ghost.speed = Std.int(ghostSpeed / 2);
		} else if (ghost.mode != Constants.GhostMode.FLEE && ghost.speed != ghostSpeed) {
			ghost.speed = ghostSpeed;
		}

		// Teleport ghost if it exits stage left or right.
		if (ghost.x <= -64) {
			ghost.x = 1792;
		} else if (ghost.x >= 1792) {
			ghost.x = -64;
		}

		// Check if ghost is in intersection.
		for (intersection in intersections.members) {
			if (intersection.x == ghost.x && intersection.y == ghost.y) {
				// Pick direction.
				if (ghost.mode == Constants.GhostMode.CHASE) {
					if (ghost == blinky) {
						ghost.newDirection = ghost.findDirection(Std.int(player.x), Std.int(player.y), intersection.getPossibleDirections(walls));
					} else if (ghost == pinky) {
						// Target spot 256 pixels in front of player.
						var targetX:Int;
						var targetY:Int;

						// Determine pinky's target based on player's direction.
						switch (player.direction) {
							case Constants.Direction.LEFT:
								targetX = Std.int(player.x) - 256;
								targetY = Std.int(player.y);
							case Constants.Direction.RIGHT:
								targetX = Std.int(player.x) + 256;
								targetY = Std.int(player.y);
							case Constants.Direction.UP:
								targetX = Std.int(player.x);
								targetY = Std.int(player.y) - 256;
							case Constants.Direction.DOWN:
								targetX = Std.int(player.x);
								targetY = Std.int(player.y) + 256;
						}

						ghost.newDirection = ghost.findDirection(targetX, targetY, intersection.getPossibleDirections(walls));
					} else if (ghost == inky) {
						var targetX:Int;
						var targetY:Int;

						switch (player.direction) {
							case Constants.Direction.LEFT:
								targetX = Std.int(player.x) - 128;
								targetY = Std.int(player.y);
							case Constants.Direction.RIGHT:
								targetX = Std.int(player.x) + 128;
								targetY = Std.int(player.y);
							case Constants.Direction.UP:
								targetX = Std.int(player.x);
								targetY = Std.int(player.y) - 128;
							case Constants.Direction.DOWN:
								targetX = Std.int(player.x);
								targetY = Std.int(player.y) + 128;
						}

						// Calculate vector from blinky to new target position.
						var vectorX:Float = targetX - blinky.x;
						var vectorY:Float = targetY - blinky.y;

						// Double vector
						targetX = Std.int(blinky.x + vectorX * 2);
						targetY = Std.int(blinky.y + vectorY * 2);

						ghost.newDirection = ghost.findDirection(targetX, targetY, intersection.getPossibleDirections(walls));
					} else if (ghost == clyde) {
						var targetX:Int;
						var targetY:Int;

						// Find distance from player (Euclidean distance fromula).
						var distanceToPlayer: Float = Math.sqrt(Math.pow(Std.int(player.x) - ghost.x, 2) + Math.pow(Std.int(player.y) - ghost.y, 2));

						if (distanceToPlayer > 512) {
							targetX = Std.int(player.x);
							targetY = Std.int(player.y);
						} else {
							targetX = 0;
							targetY = 560;
						}

						ghost.newDirection = ghost.findDirection(targetX, targetY, intersection.getPossibleDirections(walls));
					}
				} else if (ghost.mode == Constants.GhostMode.SCATTER) {
					if (ghost == blinky) {
						var targetX = 1728;
						var targetY = 128;
						ghost.newDirection = ghost.findDirection(targetX, targetY, intersection.getPossibleDirections(walls));
					} else if (ghost == pinky) {
						var targetX = 0;
						var targetY = 128;
						ghost.newDirection = ghost.findDirection(targetX, targetY, intersection.getPossibleDirections(walls));
					} else if (ghost == inky) {
						var targetX = 1728;
						var targetY = 2240;
						ghost.newDirection = ghost.findDirection(targetX, targetY, intersection.getPossibleDirections(walls));
					} else if (ghost == clyde) {
						var targetX = 0;
						var targetY = 2240;
						ghost.newDirection = ghost.findDirection(targetX, targetY, intersection.getPossibleDirections(walls));
					}
				} else {
					ghost.newDirection = getRandomDirection();
				}

				ghost.changeDirection();
				break;
			}
		}

		// Manage flee timer.
		if (ghost.mode == Constants.GhostMode.FLEE) {
			ghostFleeTime.set(ghost, ghostFleeTime.get(ghost) + elapsed);
			if (ghostFleeTime.get(ghost) >= ghostFleeDuration) {
				makeGhostRoam(ghost);
			}
		}

		// Manage pen timer.
		if (ghost.mode == Constants.GhostMode.PEN) {
			ghostPenTime.set(ghost, ghostPenTime.get(ghost) + elapsed);
			if (ghost == blinky && ghostPenTime.get(ghost) >= 0.0) {
				freeGhost(ghost);
				// Reset pen timer.
				ghostPenTime.set(ghost, 0.0);
			} else if (ghost == pinky && ghostPenTime.get(ghost) >= 5.0) {
				freeGhost(ghost);
				// Reset pen timer.
				ghostPenTime.set(ghost, 0.0);
			} else if (ghost == inky && ghostPenTime.get(ghost) >= 10.0) {
				freeGhost(ghost);
				// Reset pen timer.
				ghostPenTime.set(ghost, 0.0);
			} else if (ghost == clyde && ghostPenTime.get(ghost) >= 15.0) {
				freeGhost(ghost);
				// Reset pen timer.
				ghostPenTime.set(ghost, 0.0);
			}
		}

		// Check for collision between ghost and player.
		if (FlxG.overlap(player, ghost)) {
			if (ghost.mode == Constants.GhostMode.FLEE) {
				ghostAte(ghost);
			} else if (ghost.mode == Constants.GhostMode.CHASE || ghost.mode == Constants.GhostMode.SCATTER) {
				playerAte();
			}
		}

		// Logic for ghost pen mode.
		if (ghost.mode == Constants.GhostMode.PEN) {
			if (ghost.y <= 1014) {
				ghost.newDirection = Constants.Direction.DOWN;
				ghost.changeDirection();
			} else if (ghost.y >= 1146) {
				ghost.newDirection = Constants.Direction.UP;
				ghost.changeDirection();
			}
		}
	}

	private function ghostSounds():Void {
		if (blinky.mode == Constants.GhostMode.ATE || pinky.mode == Constants.GhostMode.ATE || inky.mode == Constants.GhostMode.ATE || clyde.mode == Constants.GhostMode.ATE) {
			ghostEyeSound.play(false);
		} else if (blinky.mode == Constants.GhostMode.FLEE || pinky.mode == Constants.GhostMode.FLEE || inky.mode == Constants.GhostMode.FLEE || clyde.mode == Constants.GhostMode.FLEE) {
			ghostFleeSound.play(false);
		} else {
			ghostRoamSound.play(false);
		}
	}

	private function ghostFollowPath(ghost:Ghost, x:Int, y:Int, elapsed:Float):Void {
		// Find path to point.
		if (ghost.pathPoints == null || ghost.mode == Constants.GhostMode.CHASE) {
			// Center ghost on intersection.
			for (intersection in intersections.members) {
				if (FlxG.overlap(ghost, intersection)) {
					ghost.x = intersection.x;
					ghost.y = intersection.y;
					break;
				}
			}

			pathfinder.diagonalPolicy = diagonalPolicy;
			ghost.pathPoints = pathfinder.findPath(cast walls, FlxPoint.weak(ghost.x + ghost.width / 2, ghost.y + ghost.height / 2), FlxPoint.weak(x + ghost.width / 2, y + ghost.height / 2), simplify);
			ghost.path.start(ghost.pathPoints, 1000.0, FORWARD, false, true);
		}

		// Follow path.
		if (ghost.pathPoints != null) {
			ghost.path.update(elapsed);
		}

		// Stop ghost
		if (ghost.x == x && ghost.y == y) {
			ghost.path.cancel();
			//ghost.velocity.x = ghost.velocity.y = 0;
			ghost.pathPoints = null;
			if (ghost.mode == Constants.GhostMode.EXIT_PEN) {
				makeGhostRoam(ghost);
				ghost.newDirection = Constants.Direction.LEFT;
				ghost.changeDirection();
			} else if (ghost.mode == Constants.GhostMode.ATE) {
				resetGhost(ghost);
			}
		}
	}

	private function resetGhost(ghost:Ghost):Void {
		// Remove paths.
		ghost.path.cancel();
		ghost.pathPoints = null;

		// Reset pen timer.
		ghostPenTime.set(ghost, 0.0);

		// Move ghost to pen.
		if (ghost == blinky) {
			ghost.x = 864;
			ghost.y = 896;
			ghost.newDirection = Constants.Direction.LEFT;
			ghost.changeDirection();
			ghost.isVertical = false;
		} else if (ghost == pinky) {
			ghost.x = 736;
			ghost.y = 1024;
		} else if (ghost == inky) {
			ghost.x = 864;
			ghost.y = 1156;
		} else if (ghost == clyde) {
			ghost.x = 992;
			ghost.y = 1024;
		}

		colorGhost(ghost);

		// Set ghost to pen mode.
		ghost.mode = Constants.GhostMode.PEN;
	}

	private function freeGhost(ghost:Ghost):Void {
		if (ghost.mode == Constants.GhostMode.PEN) {
			ghost.mode = Constants.GhostMode.EXIT_PEN;
		}
	}

	private function getRandomDirection():Constants.Direction {
		// Generate random integer.
		var randomIndex = Math.floor(Math.random() * 4);

		// Return a direction based on random index.
		switch (randomIndex) {
			case 0: return Constants.Direction.LEFT;
			case 1: return Constants.Direction.RIGHT;
			case 2: return Constants.Direction.UP;
			case 3: return Constants.Direction.DOWN;
			default: return Constants.Direction.LEFT;
		}
	}

	private function playerTouchDot(player:Player, dot:Dot) {
		if (dot.alive && dot.exists) {
			dot.kill();
			dotSound.play(false);
			score += Constants.DOT_VALUE;
			extraLifeScore += Constants.DOT_VALUE;
			hud.addToScore(Constants.DOT_VALUE);
			dotCount++;
		}
	}

	private function playerTouchBigDot(player:Player, bigDot:BigDot) {
		if (bigDot.alive && bigDot.exists) {
			bigDot.kill();
			bigDotSound.play(false);
			score += Constants.BIG_DOT_VALUE;
			extraLifeScore += Constants.BIG_DOT_VALUE;
			hud.addToScore(Constants.BIG_DOT_VALUE);
			dotCount++;

			makeGhostFlee(blinky);
			makeGhostFlee(pinky);
			makeGhostFlee(inky);
			makeGhostFlee(clyde);
		}
	}

	private function playerAte() {
		freezeGame(1000);

		playerAteSound.play(false);

		// Reduce player lives.
		lives--;
		hud.removeLife();

		if (lives > 0) {

			// Reset Ghosts.
			resetGhost(blinky);
			resetGhost(pinky);
			resetGhost(inky);
			resetGhost(clyde);

			// Return player to starting position.
			resetPlayer();

			// Reset fruit.
			resetFruit();
		} else {
			//Game Over.
			gameOver = true;
			player.x = -1000;
			player.y = -1000;
			remove(player);
			gameOverScreen.show();
			gameOverChime.play(false);
		}
	}

	private function resetPlayer() {
		player.x = 864;
		player.y = 1664;
		player.newDirection = Constants.Direction.LEFT;
		player.changeDirection();
		player.isVertical = false;
	}

	private function makeGhostFlee(ghost:Ghost):Void {
		if (ghost.mode == Constants.GhostMode.CHASE || ghost.mode == Constants.GhostMode.SCATTER || ghost.mode == Constants.GhostMode.FLEE) {
			ghost.mode = Constants.GhostMode.FLEE;

			// Reset flee timer.
			ghostFleeTime.set(ghost, 0.0);

			// Switch direction
			if (ghost.direction == Constants.Direction.LEFT) {
				ghost.newDirection = Constants.Direction.RIGHT;
			} else if (ghost.direction == Constants.Direction.RIGHT) {
				ghost.newDirection = Constants.Direction.LEFT;
			} else if (ghost.direction == Constants.Direction.UP) {
				ghost.newDirection = Constants.Direction.DOWN;
			} else if (ghost.direction == Constants.Direction.DOWN) {
				ghost.newDirection = Constants.Direction.UP;
			}

			// Change Graphic.
			ghost.makeGraphic(Constants.GHOST_SIZE, Constants.GHOST_SIZE, FlxColor.BLUE);

			// Change Speed.
			if (ghost.speed == ghostSpeed) {
				ghost.speed = Std.int(ghost.speed / 2);
			}
		}
	}

	private function makeGhostRoam(ghost:Ghost):Void {
		if (ghost.mode == Constants.GhostMode.FLEE || ghost.mode == Constants.GhostMode.EXIT_PEN) {
			ghost.mode = Constants.GhostMode.SCATTER;
			//ghost.mode = Constants.GhostMode.CHASE;

			colorGhost(ghost);

			ghost.speed = ghostSpeed;

			ghostFleeTime.set(ghost, 0.0);
		}
	}

	private function colorGhost(ghost:Ghost):Void {
		if (ghost == blinky)
			ghost.makeGraphic(Constants.GHOST_SIZE, Constants.GHOST_SIZE, FlxColor.RED);
		else if (ghost == pinky)
			ghost.makeGraphic(Constants.GHOST_SIZE, Constants.GHOST_SIZE, FlxColor.PINK);
		else if (ghost == inky)
			ghost.makeGraphic(Constants.GHOST_SIZE, Constants.GHOST_SIZE, FlxColor.CYAN);
		else if (ghost == clyde)
			ghost.makeGraphic(Constants.GHOST_SIZE, Constants.GHOST_SIZE, FlxColor.ORANGE);
	}

	private function ghostAte(ghost:Ghost):Void {
		ghostAteSound.play(false);
		ghost.mode = Constants.GhostMode.ATE;
		ghost.makeGraphic(Constants.GHOST_SIZE, Constants.GHOST_SIZE, FlxColor.GREEN);
		freezeGame(500);

		if (ghostsEatenInFlee < 4) {
			score += Std.int(Constants.GHOST_POINTS * Math.pow(2, ghostsEatenInFlee));
			extraLifeScore += Std.int(Constants.GHOST_POINTS * Math.pow(2, ghostsEatenInFlee));
			hud.addToScore(Std.int(Constants.GHOST_POINTS * Math.pow(2, ghostsEatenInFlee)));
			ghostsEatenInFlee += 1;
		} else {
			ghostsEatenInFlee = 0;
			score += Std.int(Constants.GHOST_POINTS * Math.pow(2, ghostsEatenInFlee));
			extraLifeScore += Std.int(Constants.GHOST_POINTS * Math.pow(2, ghostsEatenInFlee));
			hud.addToScore(Std.int(Constants.GHOST_POINTS * Math.pow(2, ghostsEatenInFlee)));
		}

	}

	private function toggleChaseScatter(ghost:Ghost):Void {
		if (ghost.mode == Constants.GhostMode.CHASE) {
			ghost.mode = Constants.GhostMode.SCATTER;
		} else if (ghost.mode == Constants.GhostMode.SCATTER) {
			ghost.mode = Constants.GhostMode.CHASE;
		}
	}

	private function placeEntities(entity:EntityData):Void {
		if (entity.name == "player" && stage == 1) {
			player.setPosition(entity.x, entity.y);
		} else if (entity.name == "intersection" && stage == 1) {
			intersections.add(new Intersection(entity.x, entity.y));
		} else if (entity.name == "dot") {
			dots.add(new Dot(entity.x, entity.y));
			//dotGoal++;
		} else if (entity.name == "bigDot") {
			bigDots.add(new BigDot(entity.x, entity.y));
			//dotGoal++;
		} else if (entity.name == "blinky" && stage == 1) {
			blinky.setPosition(entity.x, entity.y);
		} else if (entity.name == "pinky" && stage == 1) {
			pinky.setPosition(entity.x, entity.y);
		} else if (entity.name == "inky" && stage == 1) {
			inky.setPosition(entity.x, entity.y);
		} else if (entity.name == "clyde" && stage == 1) {
			clyde.setPosition(entity.x, entity.y);
		}
	}
}
