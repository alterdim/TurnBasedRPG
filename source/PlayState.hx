package;

import entities.Enemy;
import entities.Player;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxState;
import flixel.addons.editors.ogmo.FlxOgmo3Loader;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.tile.FlxTilemap;
import haxe.macro.Expr.Case;

class PlayState extends FlxState
{
	var player:Player;
	var map:FlxOgmo3Loader;
	var walls:FlxTilemap;
	var enemies:FlxTypedGroup<Enemy>;
	var hud:HUD;
	var money:Int = 0;
	var health:Int = 3;

	override public function create()
	{
		initializeEntities();
		addEntities();
		FlxG.camera.follow(player, TOPDOWN, 1);
		super.create();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		FlxG.collide(player, walls);
		FlxG.collide(enemies, walls);
		enemies.forEachAlive(checkEnemyVision);
	}

	function checkEnemyVision(enemy:Enemy)
	{
		if (walls.ray(enemy.getMidpoint(), player.getMidpoint()))
		{
			enemy.seesPlayer = true;
			enemy.playerPosition = player.getMidpoint();
		}
		else
		{
			enemy.seesPlayer = false;
		}
	}

	function initializeEntities()
	{
		hud = new HUD();
		player = new Player();
		enemies = new FlxTypedGroup<Enemy>();
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
			case "enemy":
				enemies.add(new Enemy(entity.x + 4, entity.y, REGULAR));
			case "boss":
				enemies.add(new Enemy(entity.x + 4, entity.y, BOSS));
		}
	}

	function addEntities()
	{
		add(walls);
		add(hud);
		add(player);
		add(enemies);
	}
}
