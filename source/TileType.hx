package;

import flash.display.BitmapData;
import flixel.system.FlxAssets;
import haxe.ds.Vector;
import haxe.ds.StringMap;

enum Edge {
	Grass;
	Road;
	City;
}

enum Direction {
	North;
	East;
	South;
	West;
}

class Directions {
	public static function toIndex(d : Direction, rotation : Int = 0) : Int
	{
		var index = Type.enumIndex(d);

		return (index + rotation) % 4;
	}
}

class TileType 
{
	public var edges(default, null) : Vector<Edge>;
	public var bitmapData(default, null) : BitmapData;
	public var name(default, null) : String;

	public function new(name : String, north : Edge, east : Edge, south : Edge, west : Edge)
	{
		this.name = name;
		this.bitmapData = FlxAssets.getBitmapData("assets/images/tiles/" + name + ".png");
		this.edges = new Vector<Edge>(4);
		edges[Directions.toIndex(North)] = north;
		edges[Directions.toIndex(East)] = east;
		edges[Directions.toIndex(South)] = south;
		edges[Directions.toIndex(West)] = west;
	}

	static var types : StringMap<TileType>;
	static function __init__()
	{
		types = new StringMap<TileType>();
	}

	public static function loadTiles()
	{
		types.set("initial-tile", new TileType("initial-tile", City, Road, Grass, Road));
		types.set("straight-road", new TileType("straight-road", Grass, Road, Grass, Road));
		types.set("ell-road", new TileType("ell-road", Road, Grass, Grass, Road));
		types.set("jay-road", new TileType("jay-road", Road, Road, Grass, Grass));
	}

	public static function get(name : String)
	{
		if (!types.exists(name))
			throw "Invalid tile name '" + name + "'";

		return types.get(name);
	}
}
