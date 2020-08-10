import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.system.debug.Window;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;

class HUD extends FlxTypedGroup<FlxSprite>
{
	var background:FlxSprite;
	var healthCounter:FlxText;
	var moneyCounter:FlxText;
	var healthIcon:FlxSprite;
	var moneyIcon:FlxSprite;

	public function new()
	{
		super();
		background = new FlxSprite().makeGraphic(FlxG.width, 20, FlxColor.BLACK);
		FlxSpriteUtil.drawRect(background, 0, 19, FlxG.width, 1, FlxColor.WHITE);
		healthCounter = new FlxText(16, 2, 0, "3 / 3", 8);
		healthCounter.setBorderStyle(SHADOW, FlxColor.GRAY, 1, 1);
		moneyCounter = new FlxText(0, 2, 0, "0", 8);
		moneyCounter.setBorderStyle(SHADOW, FlxColor.GRAY, 1, 1);
		healthIcon = new FlxSprite(1, healthCounter.y - 1, AssetPaths.health__png);
		moneyIcon = new FlxSprite(FlxG.width - 16, moneyCounter.y, AssetPaths.coin__png);
		moneyCounter.alignment = RIGHT;
		moneyCounter.x = moneyIcon.x - moneyCounter.width - 4;
		add(background);
		add(healthIcon);
		add(moneyIcon);
		add(healthCounter);
		add(moneyCounter);
		forEach(function(sprite) sprite.scrollFactor.set(0, 0));
	}

	public function updateHUD(health:Int, money:Int)
	{
		healthCounter.text = health + " / 3";
		moneyCounter.text = Std.string(money);
		moneyCounter.x = moneyIcon.x - moneyCounter.width - 4;
	}
}
