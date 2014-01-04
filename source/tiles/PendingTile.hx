package tiles;

import flixel.FlxG;
import flixel.FlxSprite;

enum PositionState
{
	InvalidNeighbors;
	NoNeighbors;
	ValidPosition;
}

class PendingTile extends TileBase
{
	public var boardX(default, null) : Int;
	public var boardY(default, null) : Int;

	private var board : Board;
	private var invalidPositionMarker : FlxSprite;
	private var validPositionMarker : FlxSprite;

	private var rotationDirty : Bool = false;

	public function new(board : Board, type : TileType)
	{
		super(type, 0);

		this.board = board;

		this.validPositionMarker = new FlxSprite("assets/images/valid-marker.png");
		this.invalidPositionMarker = new FlxSprite("assets/images/invalid-marker.png");
		this.validPositionMarker.visible = this.invalidPositionMarker.visible = false;

		board.add(this.validPositionMarker);
		board.add(this.invalidPositionMarker);
	}

	public override function destroy()
	{
		super.destroy();

		this.validPositionMarker.visible = this.invalidPositionMarker.visible = false;
		this.validPositionMarker = this.invalidPositionMarker = null;
	}

	public function createBoardTile() : BoardTile
	{
		return new BoardTile(boardX, boardY, type, rotation);
	}

	public override function update()
	{
		super.update();

		x = FlxG.mouse.x;
		y = FlxG.mouse.y;

		var newBoardX = Math.ceil(x / TileBase.TILE_SIZE - GameClass.BOARD_SIZE / 2.0);
		var newBoardY = Math.ceil(y / TileBase.TILE_SIZE - GameClass.BOARD_SIZE / 2.0);

		if (rotationDirty || newBoardX != boardX || newBoardY != boardY)
		{
			rotationDirty = false;
			boardX = newBoardX;
			boardY = newBoardY;

			if (board.getTile(boardX, boardY) != null)
			{
				invalidPositionMarker.visible = validPositionMarker.visible = false;
			}
			else
			{
				var state = getPositionState();
				if (state == NoNeighbors)
				{
					invalidPositionMarker.visible = validPositionMarker.visible = false;
				}
				else
				{
					invalidPositionMarker.visible = (state == InvalidNeighbors);
					validPositionMarker.visible = (state == ValidPosition);
				}
			}

			validPositionMarker.x = invalidPositionMarker.x = Board.getX(boardX);
			validPositionMarker.y = invalidPositionMarker.y = Board.getY(boardY);
		}
	}

	public function getPositionState() : PositionState
	{
		var anyValidNeighbors = false;

		var tileNorth = board.getTile(boardX, boardY - 1);
		if (tileNorth != null)
		{
			if (getEdge(North) != tileNorth.getEdge(South))
				return InvalidNeighbors;
			anyValidNeighbors = true;
		}

		var tileEast = board.getTile(boardX + 1, boardY);
		if (tileEast != null)
		{
			if (getEdge(East) != tileEast.getEdge(West))
				return InvalidNeighbors;
			anyValidNeighbors = true;
		}

		var tileSouth = board.getTile(boardX, boardY + 1);
		if (tileSouth != null)
		{
			if (getEdge(South) != tileSouth.getEdge(North))
				return InvalidNeighbors;
			anyValidNeighbors = true;
		}

		var tileWest = board.getTile(boardX - 1, boardY);
		if (tileWest != null)
		{
			if (getEdge(West) != tileWest.getEdge(East))
				return InvalidNeighbors;
			anyValidNeighbors = true;
		}

		if (anyValidNeighbors)
			return ValidPosition;
		else
			return NoNeighbors;
	}

	private override function set_rotation(newRotation : Int) : Int
	{
		rotationDirty = true;
		return super.set_rotation(newRotation);
	}
}
