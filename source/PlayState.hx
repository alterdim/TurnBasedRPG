package;

import entities.Enemy;
import entities.Interactable;
import entities.Player;
import entities.zone1.Todd;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxState;
import flixel.addons.editors.ogmo.FlxOgmo3Loader;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.gamepad.id.PSVitaID;
import flixel.tile.FlxTilemap;
import haxe.macro.Expr.Case;

using flixel.util.FlxSpriteUtil;

class PlayState extends FlxState
{
	var player:Player;
	var map:FlxOgmo3Loader;
	var walls:FlxTilemap;
	var enemies:FlxTypedGroup<Enemy>;
	var interactables:FlxTypedGroup<Interactable>;
	var todd:Todd;
	var hud:HUD;
	var money:Int = 0;
	var health:Int;
	var inCombat:Bool = false;
	var combatHud:CombatHUD;
	var npcCooldown:Int = 0;

	var choiceHud:ChoiceHUD;
	var inChoice:Bool = false;
	var currentResult:String;

	override public function create()
	{
		trace("hello world");
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
		else if (inChoice && !choiceHud.visible)
		{
			currentResult = choiceHud.outcome.textContent;
			inChoice = false;
			player.active = true;
			enemies.active = true;
		}
		else
		{
			FlxG.collide(player, walls);
			FlxG.collide(enemies, walls);
			enemies.forEachAlive(checkEnemyVision);
			FlxG.overlap(player, enemies, playerTouchEnemy);
			if (npcCooldown == 0 && !inChoice)
				FlxG.overlap(player, interactables, startChoice);
			else if (!inChoice)
				npcCooldown--;
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
		todd = new Todd();
		choiceHud = new ChoiceHUD();
		hud = new HUD(player);
		interactables = new FlxTypedGroup<Interactable>();
		interactables.add(todd);
		enemies = new FlxTypedGroup<Enemy>();
		map = new FlxOgmo3Loader(AssetPaths.turnBasedRPG__ogmo, AssetPaths.room_001__json);
		combatHud = new CombatHUD(player);
		walls = map.loadTilemap(AssetPaths.gbaTiles__png, "walls");
		walls.follow();
		walls.setTileProperties(1, FlxObject.NONE);
		walls.setTileProperties(2, FlxObject.ANY);
		walls.setTileProperties(3, FlxObject.ANY);
		walls.setTileProperties(4, FlxObject.ANY);
		walls.setTileProperties(5, FlxObject.ANY);
		walls.setTileProperties(6, FlxObject.ANY);
		walls.setTileProperties(8, FlxObject.ANY);
		walls.setTileProperties(9, FlxObject.ANY);
		walls.setTileProperties(10, FlxObject.ANY);
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

	function startChoice(player:Player, interactable:Interactable)
	{
		inChoice = true;
		player.active = false;
		enemies.active = false;
		npcCooldown = 100;
		choiceHud.pushChoices(interactable.getChoices());
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
			case "todd":
				todd.setPosition(entity.x, entity.y);
		}
	}

	function addEntities()
	{
		add(walls);
		add(player);
		add(enemies);
		add(interactables);
		add(hud);
		add(choiceHud);
		add(combatHud);
	}
}
