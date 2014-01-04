package tiles;

import flixel.FlxSprite;

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

	public function getEdge(direction : Direction) : Edge
	{
		return type.edges[Directions.toIndex(direction, rotation)];
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
			"N: " + getEdge(North) + " " +
			"E: " + getEdge(East) + " " +
			"S: " + getEdge(South) + " " +
			"W: " + getEdge(West);
	}
}
