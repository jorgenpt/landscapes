package;

import flixel.FlxG;
import flixel.group.FlxGroup;
import flixel.util.FlxPoint;
import haxe.ds.IntMap;

class Board extends FlxGroup
{
	var tiles : IntMap<IntMap<Tile>>;

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

	public function new()
	{
		super();

		TileType.loadTiles();

		tiles = new IntMap<IntMap<Tile>>();

		var tile = new Tile(0, 0, "initial-tile");
		insertTile(tile);
		FlxG.camera.focusOn(tile.getMidpoint());

		insertTile(new Tile(1, 0, "straight-road"));
		insertTile(new Tile(2, 0, "straight-road"));
		insertTile(new Tile(3, -1, "straight-road", 3));
	}
}