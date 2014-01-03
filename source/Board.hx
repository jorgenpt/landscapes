package;

import flixel.FlxG;
import flixel.group.FlxGroup;
import flixel.util.FlxPoint;
import haxe.ds.IntMap;

class Board extends FlxGroup
{
	var tiles : IntMap<IntMap<Tile>>;
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

		tiles = new IntMap<IntMap<Tile>>();

		var tile = new Tile(0, 0, "initial-tile");
		insertTile(tile);
		FlxG.camera.focusOn(tile.getMidpoint());
	}

	public function getTile(x : Int, y : Int) : Null<Tile>
	{
		var column = tiles.get(x);
		if (column == null)
			return null;

		return column.get(y);
	}

	public function insertTile(tile : Tile)
	{
		return setTile(tile.boardX, tile.boardY, tile);
	}

	public function setTile(x : Int, y : Int, tile : Tile)
	{
		var column = tiles.get(x);
		if (column == null)
			tiles.set(x, column = new IntMap<Tile>());

		var oldTile = column.get(y);
		if (oldTile != null)
			replace(oldTile, tile);
		else
			add(tile);

		column.set(y, tile);
	}

	public override function update()
	{
		super.update();

		if (FlxG.mouse.justPressed)
		{
			if (pendingTile == null)
			{
				FlxG.mouse.hide();
				var type = remainingTiles.splice(Std.random(remainingTiles.length), 1).pop();
				pendingTile = new PendingTile(this, type);
				add(pendingTile);
			}
			else
			{
				if (pendingTile.getPositionState() == ValidPosition)
				{
					insertTile(pendingTile.createTile());
					FlxG.mouse.show();
					remove(pendingTile);
					pendingTile.destroy();
					pendingTile = null;
				}
			}
		}

		if (FlxG.keys.justPressed.SPACE && pendingTile != null)
			pendingTile.rotate();
	}

	public static function getX(boardX : Int)
	{
		return (GameClass.BOARD_SIZE / 2.0 + boardX - 1) * TileBase.TILE_SIZE;
	}

	public static function getY(boardY : Int)
	{
		return (GameClass.BOARD_SIZE / 2.0 + boardY - 1) * TileBase.TILE_SIZE;
	}
}