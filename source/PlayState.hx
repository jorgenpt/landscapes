package;

import flixel.FlxG;
import flixel.FlxState;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{
	public var board(default, null) : Board;

	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		// Set a background color
		FlxG.cameras.bgColor = 0xff131c1b;
		// Show the mouse (in case it hasn't been disabled)
		#if !FLX_NO_MOUSE
		FlxG.mouse.show();
		#end

		FlxG.log.redirectTraces = false;

		board = new Board();
		add(board);

		super.create();
	}
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		board = null;

		super.destroy();
	}

	public inline static function clamp(value:Float, min:Float, max:Float):Float
	{
	    if (value < min)
	        return min;
	    else if (value > max)
	        return max;
	    else
	        return value;
    }

	public override function update():Void
	{
		super.update();

		if (FlxG.mouse.wheel != 0)
		{
			// TODO: Make this zoom at the center point or towards the pointed at location.
			FlxG.camera.zoom = clamp(FlxG.camera.zoom + FlxG.mouse.wheel/100.0, 0.5, 2.0);
		}
	}	
}
