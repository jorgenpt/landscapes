package;

import flixel.FlxG;
import flixel.group.FlxGroup;
import flixel.util.FlxPoint;
import haxe.ds.IntMap;

import tiles.*;
import tiles.Direction;
import tiles.Quadrant;

typedef BoardTiles = IntMap<IntMap<BoardTile>>;
typedef Node = { quadrant : Quadrant, tile : BoardTile, cameFrom : Direction };
typedef CityNode = { edge : Direction, tile : BoardTile };

class Board extends FlxGroup
{
	var tiles : BoardTiles;
	var remainingTiles : Array<TileType>;
	var pendingTile : Null<PendingTile>;

	public function new()
	{
		super();

		TileType.loadTiles();

		remainingTiles = new Array<TileType>();
		for (name in TileType.getAllNames())
		{
			var type = TileType.get(name);
			for (i in 0 ... type.boardCount)
				remainingTiles.push(type);
		}

		tiles = new BoardTiles();

		var tile = new BoardTile(0, 0, "initial-tile");
		insertTile(tile);
		FlxG.camera.focusOn(tile.getMidpoint());
	}

	public function getTile(x : Int, y : Int) : Null<BoardTile>
	{
		var column = tiles.get(x);
		if (column == null)
			return null;

		return column.get(y);
	}

	public function insertTile(tile : BoardTile)
	{
		return setTile(tile.boardX, tile.boardY, tile);
	}

	public function setTile(x : Int, y : Int, tile : BoardTile)
	{
		var column = tiles.get(x);
		if (column == null)
			tiles.set(x, column = new IntMap<BoardTile>());

		var oldTile = column.get(y);
		if (oldTile != null)
			replace(oldTile, tile);
		else
			add(tile);

		column.set(y, tile);

		updateCities(x, y);
	}


	private var dragDistance : Float = 0.0;
	private var lastMouseDrag : FlxPoint;

	public override function update()
	{
		super.update();

		if (FlxG.mouse.justPressed)
		{
			lastMouseDrag = new FlxPoint(FlxG.mouse.screenX, FlxG.mouse.screenY);
		}
		else if (FlxG.mouse.pressed)
		{
			var newMouseDrag = new FlxPoint(FlxG.mouse.screenX, FlxG.mouse.screenY);
			var distance = newMouseDrag.distanceTo(lastMouseDrag);

			FlxG.camera.scroll.x += (lastMouseDrag.x - newMouseDrag.x);
			FlxG.camera.scroll.y += (lastMouseDrag.y - newMouseDrag.y);
			dragDistance += distance;
			lastMouseDrag = newMouseDrag;
		}
		else if (FlxG.mouse.justReleased)
		{
			// TODO: Actually have a button to click for this path, rather than single click.
			if (dragDistance < 5.0)
			{
				if (pendingTile == null)
				{
					FlxG.mouse.hide();
					// TODO: Don't crash when we run out of tiles.
					var type = remainingTiles.splice(Std.random(remainingTiles.length), 1).pop();
					pendingTile = new PendingTile(this, type);
					add(pendingTile);
				}
				else
				{
					if (pendingTile.getPositionState() == ValidPosition)
					{
						insertTile(pendingTile.createBoardTile());
						FlxG.mouse.show();
						remove(pendingTile);
						pendingTile.destroy();
						pendingTile = null;
					}
				}
			}
			dragDistance = 0.0;
			lastMouseDrag = null;
		}

		if (FlxG.keys.justPressed.SPACE && pendingTile != null)
			pendingTile.rotate();

		if (FlxG.keys.justPressed.G)
			findConnectedFromMouse();
	}

	public static function getX(boardX : Int)
	{
		return boardX * TileBase.TILE_SIZE;
	}

	public static function getY(boardY : Int)
	{
		return boardY * TileBase.TILE_SIZE;
	}

	public static function getBoardX(x : Float)
	{
		return Math.floor(x / TileBase.TILE_SIZE + 0.5);
	}

	public static function getBoardY(y : Float)
	{
		return Math.floor(y / TileBase.TILE_SIZE + 0.5);
	}

	public function getNeighbor(boardX : Int, boardY : Int, direction : Direction)
	{
		return switch (direction)
		{
			case North: getTile(boardX, boardY - 1);
			case East:  getTile(boardX + 1, boardY);
			case South: getTile(boardX, boardY + 1);
			case West:  getTile(boardX - 1, boardY);
		}
	}

	private function findConnectedFromMouse()
	{
		var boardX = getBoardX(FlxG.mouse.x);
		var boardY = getBoardY(FlxG.mouse.y);

		var initialTile = getTile(boardX, boardY);
		if (initialTile == null)
			return;

		// Find our position inside the tile.
		var offsetX = FlxG.mouse.x - getX(boardX);
		var offsetY = FlxG.mouse.y - getY(boardY);
		var initialQuadrant = Quadrants.fromCoordinate(offsetX, offsetY);

		var connectedNodes : Array<Node> = new Array<Node>();
		connectedNodes.push({ quadrant: initialQuadrant, tile: initialTile, cameFrom: null });

		var i = 0;
		while (i < connectedNodes.length)
		{
			var node = connectedNodes[i++];
			var tile = node.tile;

			// This gets all the quadrants that are a part of the same grass patch as the given quadrant.
			var quadrants = tile.findGrassGroupContainingQuadrant(node.quadrant);
			for (quadrant in quadrants)
			{
				var nearbyNodes = getNodesNearQuadrant(tile, quadrant, node.cameFrom);
				for (nearbyNode in nearbyNodes)
					connectedNodes.push(nearbyNode);
			}
		}

		trace(connectedNodes);
	}

	private function getNodesNearQuadrant(tile : BoardTile, quadrant : Quadrant, exceptFrom : Direction)
	{
		var nearbyNodes = new List<Node>();

		// What neighbors we need to look at from this quadrant, and what quadrants in them are relevant
		var directions = Quadrants.toDirections(quadrant);
		for (directionAndQuadrant in directions)
		{
			var direction = directionAndQuadrant.direction;
			if (direction == exceptFrom)
				continue;

			var neighbor = getNeighbor(tile.boardX, tile.boardY, direction);
			if (neighbor != null)
				nearbyNodes.add({ quadrant: directionAndQuadrant.quadrant, tile: neighbor, cameFrom : Directions.mirror(direction) });
		}
		return nearbyNodes;
	}

	private function updateCities(boardX : Int, boardY : Int)
	{
		var tile = getTile(boardX, boardY);
		var cityGroups = tile.getRotatedCityGroups();
		for (cityGroup in cityGroups)
		{
			var cityNumber = BoardTile.INVALID_CITY;
			for (edge in cityGroup)
			{
				var neighbor = getNeighbor(boardX, boardY, edge);
				if (neighbor != null)
				{
					cityNumber = propagateCityNumber(neighbor, Directions.mirror(edge));
					break;
				}
			}

			if (cityNumber == BoardTile.INVALID_CITY)
			{
				cityNumber = BoardTile.createNewCity();
				for (edge in cityGroup)
					tile.cities[Directions.toIndex(edge)] = cityNumber;
			}
		}
	}

	private function propagateCityNumber(initialTile : BoardTile, edge : Direction)
	{
		var cityNumber = initialTile.cities[Directions.toIndex(edge)];

		var connectedNodes : Array<CityNode> = new Array<CityNode>();
		connectedNodes.push({ edge: edge, tile: initialTile });

		var i = 0;
		while (i < connectedNodes.length)
		{
			var node = connectedNodes[i++];
			var tile = node.tile;

			var edges = tile.findCityGroupContainingEdge(node.edge);
			for (edge in edges)
			{
				tile.cities[Directions.toIndex(edge)] = cityNumber;

				var neighbor = getNeighbor(tile.boardX, tile.boardY, edge);
				if (neighbor != null)
				{
					var neighborEdgeIndex = Directions.toIndex(edge, 2);
					if (neighbor.cities[neighborEdgeIndex] == cityNumber)
						continue;

					neighbor.cities[neighborEdgeIndex] = cityNumber;
					connectedNodes.push({ edge: Directions.fromIndex(neighborEdgeIndex), tile: neighbor });
				}
			}
		}

		return cityNumber;
	}
}
