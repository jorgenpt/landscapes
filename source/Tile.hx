package;

import flixel.FlxSprite;

class Tile extends FlxSprite
{
	public static inline var TILESIZE = 64;

	public var rotation(default, null) : Int;
	public var type(default, null) : TileType;
	public var boardX(default, set) : Int;
	public var boardY(default, set) : Int;

	public function new(boardX : Int, boardY : Int, name : String, rotation : Int = 0)
	{
		super();

		this.type = TileType.get(name);
		loadRotatedGraphic(type.bitmapData, 4, -1, type.name);

		this.rotation = rotation;
		this.angle = rotation * 90;
		this.boardX = boardX;
		this.boardY = boardY;
	}

	private function set_boardX(boardX : Int)
	{
		var width = GameClass.gameWidth();
		this.x = width / 2.0 + TILESIZE * boardX;
		return this.boardX = boardX;
	}

	private function set_boardY(boardY : Int)
	{
		var height = GameClass.gameHeight();
		this.y = height / 2.0 + TILESIZE * boardY;
		return this.boardY = boardY;
	}
}
