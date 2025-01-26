# HaxeFlixel-Pac-Man
Pacman remake in HaxeFlixel

<img src="./img/example001.png" width="50%">

## Licensing
The majority of this project is licensed under the terms of the [GNU GPL v3](https://github.com/joshuaDeal/HaxeFlixel-Pac-Man/blob/main/LICENSE) with the exception of [BigMoverPathfinder.hx](https://github.com/joshuaDeal/HaxeFlixel-Pac-Man/blob/main/source/BigMoverPathfinder.hx), which is sourced from another project and licensed under the terms of the [MIT License](https://github.com/HaxeFlixel/flixel-demos/blob/487ce2c71fbb9652d5ddcc896a5cb4c5377d99bc/LICENSE.md). (More information about that file, its license, and its origin can be found in the comment lines at the start of said file.) Also, the sound effects (Which are currently placeholders) are sourced from [kenney.nl](https://kenney.nl) and were licensed via the [Create Commons 0 license](https://creativecommons.org/publicdomain/zero/1.0/).

## Unfinished
I haven't quite finished this game, but the main game loop and logic is all there. It's totally playable and still pretty fun.

### TODO
	- Graphics
		- Upscale everything (Square sprites should be something like 128x128 or 64x64)
		- Create sprite sheets / Animations
			- Player / Pacman
			- Ghosts
			- Dots
			- Fruits
		- Create or find better tiles for tilemap
		- Add graphics to main menu
		- Make hud look nicer
		- Make game over screen look nicer
	- Game progression logic (what changes between stages) should be more thought out.
	- Bugs
		- Find and fix any bugs
		- Bug with ghosts not moving or not being correctly placed inside pen when in pen mode
		- Fruit will sometimes fail to disappear after begin ate
	- Sound
		- Current sounds are all placeholders
	- Mobile device friendly touch controls / input
	- Main Menu
		- Maybe add a settings screen where the user can toggle things relating to graphics and sound effects. Things that turning on/off could improve performance on weaker devices
	- Polish
		- Trail effect when ghosts are in flee mode
		- Animation for characters switching direction
		- Animation for when player is ate by a ghost
		- Transition effects between stages
		- Cutscene / Cartoons that play between some stages
		- Animate dots
			- I want the dots to bounce up and down slightly
				- The timing of this motion should be offset based on the x positioning of the dot in order to create a wave effect. (Hopefully implementing this won't be too resource intensive)
	- Finish TODO list
		- Add more items to this list as I start to remember them
