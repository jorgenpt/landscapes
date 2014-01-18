package tiles;

import flash.display.BitmapData;
import flixel.system.FlxAssets;
import haxe.ds.Vector;
import haxe.ds.StringMap;
import tiles.Direction;
import tiles.EdgeType;
import tiles.Quadrant;

class TileType 
{
	public var edges(default, null) : Vector<EdgeType>;
	public var grassGroups(default, null) : Vector<Vector<Quadrant>>;
	public var cityGroups(default, null) : Vector<Vector<Direction>>;
	public var bitmapData(default, null) : BitmapData;
	public var name(default, null) : String;
	public var boardCount(default, null) : Int;

	public function new(name : String, tileInfo : Dynamic)
	{
		this.name = name;
		boardCount = tileInfo.count;
		bitmapData = FlxAssets.getBitmapData('assets/images/tiles/$name.png');

		var edgeList : Array<String> = tileInfo.edges;

		if (edgeList == null || edgeList.length != 4)
			throw 'edgeList not valid for tile $name: $edgeList';

		edges = new Vector<EdgeType>(4);
		edges[Directions.toIndex(North)] = EdgeTypes.fromString(edgeList[0]);
		edges[Directions.toIndex(East)] = EdgeTypes.fromString(edgeList[1]);
		edges[Directions.toIndex(South)] = EdgeTypes.fromString(edgeList[2]);
		edges[Directions.toIndex(West)] = EdgeTypes.fromString(edgeList[3]);

		grassGroups = createGroups(tileInfo.grassGroups, Quadrants.fromString);
		cityGroups = createGroups(tileInfo.cityGroups, Directions.fromString);
	}

	@:generic private function createGroups<T>(groupsList : Array<Array<String>>, fromString : String -> T)
	{
		var length = 0;
		if (groupsList != null)
			length = groupsList.length;

		var groups = new Vector<Vector<T>>(length);
		for (i in 0...length)
		{
			var elements = groupsList[i];
			groups[i] = new Vector<T>(elements.length);

			for (j in 0...elements.length)
				groups[i][j] = fromString(elements[j]);
		}

		return groups;
	}

	static var types : StringMap<TileType>;
	static function __init__()
	{
		types = new StringMap<TileType>();
	}

	public static function loadTiles()
	{
		var jsonData = openfl.Assets.getText("assets/data/tiles.json");
		var tiles = haxe.Json.parse(jsonData);
		for (tileName in Reflect.fields(tiles))
		{
			var tileInfo = Reflect.field(tiles, tileName);
			types.set(tileName, new TileType(tileName, tileInfo));
		}
	}

	public static function get(name : String)
	{
		if (!types.exists(name))
			throw 'Invalid tile name "$name"';

		return types.get(name);
	}

	public static function getAllNames()
	{
		return types.keys();
	}
}
