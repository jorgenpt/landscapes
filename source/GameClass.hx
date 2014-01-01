package;

import flash.Lib;
import flixel.FlxGame;
import flixel.FlxG;
import flixel.FlxState;

class GameClass extends FlxGame
{
	static inline var maxTileSequence = 128;
	var initialState:Class<FlxState> = PlayState; // The FlxState the game starts with.
	var zoom:Float = 0.5; // If -1, zoom is automatically calculated to fit the window dimensions.
	var framerate:Int = 60; // How many frames per second the game should run at.
	var skipSplash:Bool = false; // Whether to skip the flixel splash screen that appears in release mode.
	var startFullscreen:Bool = false; // Whether to start the game in fullscreen on desktop targets

	/**
	 * You can pretty much ignore this logic and edit the variables above.
	 */
	public function new()
	{
		super(gameWidth(), gameHeight(), initialState, zoom, framerate, framerate, skipSplash, startFullscreen);
	}

	public static inline function gameWidth() : Int
	{
		return maxTileSequence * Tile.TILESIZE;
	}

	public static inline function gameHeight() : Int
	{
		return maxTileSequence * Tile.TILESIZE;
	}
}
