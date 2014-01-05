package;

import flixel.FlxG;
import flixel.group.FlxGroup;
import flixel.util.FlxPoint;
import haxe.ds.IntMap;
import tiles.*;

typedef BoardTiles = IntMap<IntMap<BoardTile>>;

class Board extends FlxGroup
{
	// TODO: We can probably kill this completely, and allow "infinite" boards.
	static public inline var BOARD_SIZE = 128;

	var tiles : BoardTiles;
	var remainingTiles : Array<TileType>;
	var pendingTile : Null<PendingTile>;

	public function new()
	{
		super();

		TileType.loadTiles();

		remainingTiles = new Array<TileType>();
		for (name in TileType.getAllNames())
		{
			var type = TileType.get(name);
			for (i in 0 ... type.boardCount)
				remainingTiles.push(type);
		}

		tiles = new BoardTiles();

		var tile = new BoardTile(0, 0, "initial-tile");
		insertTile(tile);
		FlxG.camera.focusOn(tile.getMidpoint());
	}

	public function getTile(x : Int, y : Int) : Null<BoardTile>
	{
		if (x < (-BOARD_SIZE/2 + 1) || x > BOARD_SIZE/2)
			return null;
		if (y < (-BOARD_SIZE/2 + 1) || y > BOARD_SIZE/2)
			return null;

		var column = tiles.get(x);
		if (column == null)
			return null;

		return column.get(y);
	}

	public function insertTile(tile : BoardTile)
	{
		return setTile(tile.boardX, tile.boardY, tile);
	}

	public function setTile(x : Int, y : Int, tile : BoardTile)
	{
		var column = tiles.get(x);
		if (column == null)
			tiles.set(x, column = new IntMap<BoardTile>());

		var oldTile = column.get(y);
		if (oldTile != null)
			replace(oldTile, tile);
		else
			add(tile);

		column.set(y, tile);
	}


	private var dragDistance : Float = 0.0;
	private var lastMouseDrag : FlxPoint;

	public override function update()
	{
		super.update();

		if (FlxG.mouse.justPressed)
		{
			lastMouseDrag = new FlxPoint(FlxG.mouse.screenX, FlxG.mouse.screenY);
		}
		else if (FlxG.mouse.pressed)
		{
			var newMouseDrag = new FlxPoint(FlxG.mouse.screenX, FlxG.mouse.screenY);
			var distance = newMouseDrag.distanceTo(lastMouseDrag);

			FlxG.camera.scroll.x += (lastMouseDrag.x - newMouseDrag.x);
			FlxG.camera.scroll.y += (lastMouseDrag.y - newMouseDrag.y);
			dragDistance += distance;
			lastMouseDrag = newMouseDrag;
		}
		else if (FlxG.mouse.justReleased)
		{
			// TODO: Actually have a button to click for this path, rather than single click.
			if (dragDistance < 5.0)
			{
				if (pendingTile == null)
				{
					FlxG.mouse.hide();
					// TODO: Don't crash when we run out of tiles.
					var type = remainingTiles.splice(Std.random(remainingTiles.length), 1).pop();
					pendingTile = new PendingTile(this, type);
					add(pendingTile);
				}
				else
				{
					if (pendingTile.getPositionState() == ValidPosition)
					{
						insertTile(pendingTile.createBoardTile());
						FlxG.mouse.show();
						remove(pendingTile);
						pendingTile.destroy();
						pendingTile = null;
					}
				}
			}
			dragDistance = 0.0;
			lastMouseDrag = null;
		}

		if (FlxG.keys.justPressed.SPACE && pendingTile != null)
			pendingTile.rotate();
	}

	public static function getX(boardX : Int)
	{
		return (BOARD_SIZE / 2.0 + boardX - 1) * TileBase.TILE_SIZE;
	}

	public static function getY(boardY : Int)
	{
		return (BOARD_SIZE / 2.0 + boardY - 1) * TileBase.TILE_SIZE;
	}

	public static function getBoardX(x : Float)
	{
		return Math.ceil(x / TileBase.TILE_SIZE - BOARD_SIZE / 2.0);
	}

	public static function getBoardY(y : Float)
	{
		return Math.ceil(y / TileBase.TILE_SIZE - BOARD_SIZE / 2.0);
	}

	public function getNeighbor(boardX : Int, boardY : Int, direction : Direction)
	{
		return switch (direction)
		{
			case North: getTile(boardX, boardY - 1);
			case East:  getTile(boardX + 1, boardY);
			case South: getTile(boardX, boardY + 1);
			case West:  getTile(boardX - 1, boardY);
		}
	}
}
