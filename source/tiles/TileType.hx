package tiles;

import flash.display.BitmapData;
import flixel.system.FlxAssets;
import haxe.ds.Vector;
import haxe.ds.StringMap;

enum Edge {
	Grass;
	Road;
	City;
}

class Edges {
	public static function fromString(edgeName : String)
	{
		return switch (edgeName.toUpperCase())
		{
			case "G": Grass;
			case "R": Road;
			case "C": City;
			default: throw 'Invalid edgeName: $edgeName';
		}
	}
}

enum Direction {
	West;
	South;
	East;
	North;
}

class Directions {
	public static function toIndex(d : Direction, rotation : Int = 0) : Int
	{
		var index = Type.enumIndex(d);
		return (index + rotation) % 4;
	}
}

enum Quadrant {
	Northwest;
	Southwest;
	Southeast;
	Northeast;
}

typedef GrassGroups = Vector<Vector<Quadrant>>;

class Quadrants {
	public static function fromString(quadrantName : String)
	{
		return switch (quadrantName.toUpperCase())
		{
			case "NW": Northwest;
			case "SW": Southwest;
			case "SE": Southeast;
			case "NE": Northeast;
			default: throw 'Invalid quadrantName: $quadrantName';
		}
	}
}

class TileType 
{
	public var edges(default, null) : Vector<Edge>;
	public var grassGroups(default, null) : GrassGroups;
	public var bitmapData(default, null) : BitmapData;
	public var name(default, null) : String;
	public var boardCount(default, null) : Int;

	public function new(name : String, tileInfo : Dynamic)
	{
		this.name = name;
		boardCount = tileInfo.count;
		bitmapData = FlxAssets.getBitmapData("assets/images/tiles/" + name + ".png");

		var edgeList : Array<String> = tileInfo.edges;

		if (edgeList == null || edgeList.length != 4)
			throw "edgeList not valid for tile $name: $edgeList";

		edges = new Vector<Edge>(4);
		edges[Directions.toIndex(North)] = Edges.fromString(edgeList[0]);
		edges[Directions.toIndex(East)] = Edges.fromString(edgeList[1]);
		edges[Directions.toIndex(South)] = Edges.fromString(edgeList[2]);
		edges[Directions.toIndex(West)] = Edges.fromString(edgeList[3]);

		var grassGroupsList : Array<Array<String>> = tileInfo.grassGroups;
		if (grassGroupsList == null)
			grassGroups = new GrassGroups(0);
		else
		{
			grassGroups = new GrassGroups(grassGroupsList.length);
			for (i in 0...grassGroupsList.length)
			{
				var quadrants = grassGroupsList[i];
				grassGroups[i] = new Vector<Quadrant>(quadrants.length);

				for (j in 0...quadrants.length)
					grassGroups[i][j] = Quadrants.fromString(quadrants[j]);
			}
		}
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
			throw "Invalid tile name '" + name + "'";

		return types.get(name);
	}

	public static function getAllNames()
	{
		return types.keys();
	}
}
