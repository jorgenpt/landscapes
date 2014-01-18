package tiles;

import tiles.Direction;

enum Quadrant {
	Northwest;
	Southwest;
	Southeast;
	Northeast;
}

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

	public static function fromCoordinate(x : Float, y : Float)
	{
		if (y >= TileBase.TILE_SIZE / 2.0)
		{
			if (x < TileBase.TILE_SIZE / 2.0)
				return Southwest;
			else
				return Southeast;
		}
		else
		{
			if (x < TileBase.TILE_SIZE / 2.0)
				return Northwest;
			else
				return Northeast;
		}
	}

	public static function toDirections(quadrant : Quadrant)
	{
		return switch (quadrant)
		{
			case Northwest: [{direction: North, quadrant: Southwest}, {direction: West, quadrant: Northeast}];
			case Southwest: [{direction: South, quadrant: Northwest}, {direction: West, quadrant: Southeast}];
			case Southeast: [{direction: South, quadrant: Northeast}, {direction: East, quadrant: Southwest}];
			case Northeast: [{direction: North, quadrant: Southeast}, {direction: East, quadrant: Northwest}];
		}
	}

	public static function rotate(quadrant : Quadrant, rotation : Int)
	{
		return Type.createEnumIndex(Quadrant, (Type.enumIndex(quadrant) + rotation) % 4);
	}

	public static function toIndex(quadrant : Quadrant) : Int
	{
		return Type.enumIndex(quadrant);
	}

	public static function fromIndex(index : Int)
	{
		return Type.createEnumIndex(Quadrant, index);
	}
}