package tiles;

import haxe.ds.Vector;

class BoardTile extends TileBase
{
	static public inline var INVALID_CITY = -1;
	public var cities(default, null) : Vector<Int>;

	public var boardX(default, set) : Int;
	public var boardY(default, set) : Int;

	public function new(boardX : Int, boardY : Int, nameOrType : Dynamic, initialRotation : Int = 0)
	{
		super(nameOrType, initialRotation);

		this.cities = new Vector<Int>(4);
		for (i in 0...this.cities.length)
			this.cities[i] = INVALID_CITY;

		this.boardX = boardX;
		this.boardY = boardY;
	}

	private function set_boardX(boardX : Int)
	{
		this.x = Board.getX(boardX);
		return this.boardX = boardX;
	}

	private function set_boardY(boardY : Int)
	{
		this.y = Board.getY(boardY);
		return this.boardY = boardY;
	}

	public override function toString()
	{
		return '($boardX, $boardY) [${type.name}]';
	}

	private static var currentCity = 0;
	public static function createNewCity()
	{
		return currentCity++;
	}
}
