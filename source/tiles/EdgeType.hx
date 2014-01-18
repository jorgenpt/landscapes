package tiles;

enum EdgeType {
	Grass;
	Road;
	City;
}

class EdgeTypes {
	public static function fromString(edgeTypeName : String)
	{
		return switch (edgeTypeName.toUpperCase())
		{
			case "G": Grass;
			case "R": Road;
			case "C": City;
			default: throw 'Invalid edgeTypeName: $edgeTypeName';
		}
	}
}