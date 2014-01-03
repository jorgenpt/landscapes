package;


class Tile extends TileBase
{
	public var boardX(default, set) : Int;
	public var boardY(default, set) : Int;

	public function new(boardX : Int, boardY : Int, nameOrType : Dynamic, initialRotation : Int = 0)
	{
		super(nameOrType, initialRotation);

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
}
