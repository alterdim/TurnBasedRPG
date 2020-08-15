package abilities;

import abilities.Element;

class Spell
{
	public var name:String;
	public var cost:Int;
	public var physical:Bool;
	public var element:Element;
	public var factor:Float;
	public var critChance:Int; // 0 : always crits, 100: never crits
	public var description:String;
	public var magicBaseDamage:Int;

	public function new(name:String, cost:Int, physical:Bool, element:Element, factor:Float, critChance:Int, description:String, magicBaseDamage:Int = 0)
	{
		this.name = name;
		this.cost = cost;
		this.element = element;
		this.physical = physical;
		this.factor = factor;
		this.critChance = critChance;
		this.description = description;
		this.magicBaseDamage = magicBaseDamage;
	}
}
