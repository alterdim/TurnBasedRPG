package entities;

import abilities.Element;
import abilities.Spell;
import flixel.FlxSprite;
import haxe.display.Server.JsonServerFile;

class Entity extends FlxSprite
{
	var spellMap:Map<String, Spell>;
	var spellArray:Array<String>;

	public var hp:Int;
	public var atk:Int;
	public var int:Int;
	public var agi:Int;
	public var mp:Int;
	public var def:Int;

	public var spellBook:Array<Spell>;
	public var resistances:Map<Element, Float> = [
		Element.NONE => 1.0,
		Element.FIRE => 1.0,
		Element.WATER => 1.0,
		Element.EARTH => 1.0,
		Element.WIND => 1.0,
		Element.LIGHT => 1.0,
		Element.DARK => 1.0,
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

	public function getSpellArray()
	{
		spellArray = new Array<String>();
		for (i in spellBook)
		{
			spellArray.push(i.name);
		}
		return spellArray;
	}

	public function getSpellMap()
	{
		spellMap = new Map<String, Spell>();
		for (s in spellBook)
		{
			spellMap[s.name] = s;
		}
		return spellMap;
	}

	public function setResistance(element:Element, value:Float)
	{
		resistances.set(element, value);
	}
}
