package tiles;

import haxe.ds.Vector;

enum Direction {
	West;
	South;
	East;
	North;
}

class Directions {
	public static var all(default, null) : Vector<Direction>;
	static function __init__()
	{
		all = Vector.fromArrayCopy(Type.allEnums(Direction));
	}

	public static function fromString(directionName : String)
	{
		return switch (directionName.toUpperCase())
		{
			case "W": West;
			case "S": South;
			case "E": East;
			case "N": North;
			default: throw 'Invalid directionName: $directionName';
		}
	}

	public static function toIndex(d : Direction, rotation : Int = 0) : Int
	{
		var index = Type.enumIndex(d);
		return (index + rotation) % 4;
	}

	public static function fromIndex(index : Int)
	{
		return Type.createEnumIndex(Direction, index);
	}

	public static function rotate(d : Direction, rotation : Int)
	{
		return fromIndex(toIndex(d, rotation));
	}

	public static function mirror(d : Direction)
	{
		return rotate(d, 2);
	}
}