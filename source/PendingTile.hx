package;

class PendingTile extends TileBase
{
	public function new(name : String)
	{
		super(name, 0);
	}

	public override function update()
	{
		trace("HI");
	}
}
