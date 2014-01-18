package tiles;

import flixel.FlxSprite;

import haxe.ds.Vector;
import tiles.TileType;

class TileBase extends FlxSprite
{
	public static inline var TILE_SIZE = 64;

	public var rotation(default, set) : Int;
	public var type(default, null) : TileType;

	public function new(typeOrName : Dynamic, initialRotation : Int)
	{
		super();

		if (Std.is(typeOrName, String))
			type = TileType.get(typeOrName);
		else
			type = typeOrName;

		loadRotatedGraphic(type.bitmapData, 4, -1, type.name);

		rotation = initialRotation;
	}

	public function getEdgeType(direction : Direction) : EdgeType
	{
		return type.edges[Directions.toIndex(direction, rotation)];
	}

	private static function vectorContains<T>(haystack : Vector<T>, needle : T)
	{
		for (element in haystack)
			if (element == needle)
				return true;

		return false;
	}

	public function findGrassGroupContainingQuadrant(quadrant : Quadrant)
	{
		var unrotatedQuadrant = Quadrants.rotate(quadrant, 4 - rotation);
		for (group in type.grassGroups)
		{
			if (vectorContains(group, unrotatedQuadrant))
			{
				var connected = new Vector<Quadrant>(group.length);
				for (i in 0...group.length)
					connected[i] = Quadrants.rotate(group[i], rotation);
				return connected;
			}
		}

		return new Vector<Quadrant>(0);
	}

	public function findCityGroupContainingEdge(edge : Direction)
	{
		var groups = getRotatedCityGroups();
		for (group in groups)
		{
			if (vectorContains(group, edge))
				return group;
		}

		return new Vector<Direction>(0);
	}

	public function getRotatedCityGroups()
	{
		var cityGroups = new Vector<Vector<Direction>>(type.cityGroups.length);
		for (i in 0...cityGroups.length)
		{
			var unrotatedCityGroup = type.cityGroups[i];
			cityGroups[i] = new Vector<Direction>(unrotatedCityGroup.length);
			for (j in 0...cityGroups[i].length)
				cityGroups[i][j] = Directions.rotate(unrotatedCityGroup[j], rotation);
		}

		return cityGroups;
	}

	public function rotate()
	{
		rotation = (rotation + 1) % 4;
	}

	private function set_rotation(newRotation : Int) : Int
	{
		angle = newRotation * 90;
		return rotation = newRotation;
	}

	public override function toString()
	{
		return
			'N: ${getEdgeType(North)}' +
			'E: ${getEdgeType(East)}' +
			'S: ${getEdgeType(South)}' +
			'W: ${getEdgeType(West)}';
	}
}
