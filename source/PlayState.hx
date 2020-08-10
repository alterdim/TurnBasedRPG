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

using flixel.util.FlxSpriteUtil;

class PlayState extends FlxState
{
	var player:Player;
	var map:FlxOgmo3Loader;
	var walls:FlxTilemap;
	var enemies:FlxTypedGroup<Enemy>;
	var hud:HUD;
	var money:Int = 0;
	var health:Int;
	var inCombat:Bool = false;
	var combatHud:CombatHUD;

	override public function create()
	{
		#if FLX_MOUSE
		FlxG.mouse.visible = false;
		#end
		initializeEntities();
		addEntities();
		health = player.hp;
		FlxG.camera.follow(player, TOPDOWN, 1);
		super.create();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		if (inCombat)
		{
			if (!combatHud.visible)
			{
				health = combatHud.playerHealth;
				hud.updateHUD(health, money);
				if (combatHud.outcome == VICTORY)
				{
					combatHud.enemy.kill();
				}
				else
				{
					combatHud.enemy.flicker();
				}
				inCombat = false;
				player.active = true;
				enemies.active = true;
			}
		}
		else
		{
			FlxG.collide(player, walls);
			FlxG.collide(enemies, walls);
			enemies.forEachAlive(checkEnemyVision);
			FlxG.overlap(player, enemies, playerTouchEnemy);
		}
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
		player = new Player();
		hud = new HUD(player);
		enemies = new FlxTypedGroup<Enemy>();
		map = new FlxOgmo3Loader(AssetPaths.turnBasedRPG__ogmo, AssetPaths.room_001__json);
		combatHud = new CombatHUD(player);
		walls = map.loadTilemap(AssetPaths.tiles__png, "walls");
		walls.follow();
		walls.setTileProperties(1, FlxObject.NONE);
		walls.setTileProperties(2, FlxObject.ANY);
		map.loadEntities(placeEntities, "entities");
	}

	function playerTouchEnemy(player:Player, enemy:Enemy)
	{
		if (player.alive && player.exists && enemy.alive && enemy.exists && !enemy.isFlickering())
		{
			startCombat(player, enemy);
		}
	}

	function startCombat(player:Player, enemy:Enemy)
	{
		inCombat = true;
		player.active = false;
		enemies.active = false;
		combatHud.initCombat(player.hp, enemy);
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
		add(player);
		add(enemies);
		add(hud);
		add(combatHud);
	}
}
