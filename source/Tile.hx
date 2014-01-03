package;


class Tile extends TileBase
{
	public var boardX(default, set) : Int;
	public var boardY(default, set) : Int;

	public function new(boardX : Int, boardY : Int, name : String, rotation : Int = 0)
	{
		super(name, rotation);

		this.boardX = boardX;
		this.boardY = boardY;
	}

	private function set_boardX(boardX : Int)
	{
		this.x = (GameClass.BOARD_SIZE / 2.0 + boardX) * TileBase.TILESIZE;
		return this.boardX = boardX;
	}

	private function set_boardY(boardY : Int)
	{
		this.y = (GameClass.BOARD_SIZE / 2.0 + boardY) * TileBase.TILESIZE;
		return this.boardY = boardY;
	}
}
