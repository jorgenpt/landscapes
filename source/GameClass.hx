package;

import flash.Lib;
import flixel.FlxGame;
import flixel.FlxG;
import flixel.FlxState;

class GameClass extends FlxGame
{
	static public inline var BOARD_SIZE = 128;
	var initialState:Class<FlxState> = PlayState; // The FlxState the game starts with.
	var zoom:Float = 0.5;
	var framerate:Int = 60; // How many frames per second the game should run at.
	var skipSplash:Bool = false; // Whether to skip the flixel splash screen that appears in release mode.
	var startFullscreen:Bool = false; // Whether to start the game in fullscreen on desktop targets

	/**
	 * You can pretty much ignore this logic and edit the variables above.
	 */
	public function new()
	{
		FlxG.autoResize = true;

		var gameWidth = Math.ceil(Lib.current.stage.stageWidth / zoom);
		var gameHeight = Math.ceil(Lib.current.stage.stageHeight / zoom);
		super(gameWidth, gameHeight, initialState, zoom, framerate, framerate, skipSplash, startFullscreen);
	}
}
