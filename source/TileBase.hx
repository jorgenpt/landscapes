package;

import flixel.FlxSprite;

class TileBase extends FlxSprite
{
	public static inline var TILESIZE = 64;

	public var rotation(default, null) : Int;
	public var type(default, null) : TileType;

	public function new(name : String, rotation : Int)
	{
		super();

		this.type = TileType.get(name);
		loadRotatedGraphic(type.bitmapData, 4, -1, type.name);

		this.rotation = rotation;
		this.angle = rotation * 90;
	}
}
