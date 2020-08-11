package entities;

import abilities.Element.Elements;
import abilities.Spell;
import flixel.FlxSprite;

class Entity extends FlxSprite
{
	public var hp:Int;
	public var atk:Int;
	public var int:Int;
	public var agi:Int;
	public var mp:Int;
	public var def:Int;

	public var spellBook:Array<Spell>;
	public var resistances:Map<Elements, Float> = [
		PHYSICAL => 1.0,
		FIRE => 1.0,
		WATER => 1.0,
		EARTH => 1.0,
		THUNDER => 1.0,
		LIGHT => 1.0,
		DARK => 1.0,
	];

	public function new(x:Float = 0, y:Float = 0, spriteName:String, sizeX:Int = 16, sizeY:Int = 16)
	{
		super(x, y);
		spellBook = new Array<Spell>();
		loadGraphic("assets/images/" + spriteName + ".png", true, sizeX, sizeY);
	}

	public function learnSpell(spell:Spell)
	{
		spellBook.insert(0, spell);
	}

	public function learnSpells(spells:Array<Spell>)
	{
		for (i in spells)
		{
			learnSpell(i);
		}
	}

	public function setResistance(element:Elements, value:Float)
	{
		resistances.set(element, value);
	}
}
