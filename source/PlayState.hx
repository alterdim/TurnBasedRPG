package;

import entities.Player;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxState;
import flixel.addons.editors.ogmo.FlxOgmo3Loader;
import flixel.tile.FlxTilemap;

class PlayState extends FlxState
{
	var player:Player;
	var map:FlxOgmo3Loader;
	var walls:FlxTilemap;

	override public function create()
	{
		initializeEntities();
		addEntities();
		super.create();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		FlxG.collide(player, walls);
	}

	function initializeEntities()
	{
		player = new Player();
		map = new FlxOgmo3Loader(AssetPaths.turnBasedRPG__ogmo, AssetPaths.room_001__json);
		walls = map.loadTilemap(AssetPaths.tiles__png, "walls");
		walls.follow();
		walls.setTileProperties(1, FlxObject.NONE);
		walls.setTileProperties(2, FlxObject.ANY);
		map.loadEntities(placeEntities, "entities");
	}

	function placeEntities(entity:EntityData)
	{
		switch entity.name
		{
			case "player":
				player.setPosition(entity.x, entity.y);
		}
	}

	function addEntities()
	{
		add(walls);
		add(player);
	}
}
