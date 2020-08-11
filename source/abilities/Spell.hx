package abilities;

import abilities.Element;

class Spell
{
	public var name:String;
	public var cost:Int;
	public var physical:Bool;
	public var element:Elements;
	public var factor:Float;
	public var critChance:Float;
	public var description:String;

	public function new(name:String, cost:Int, physical:Bool, factor:Float, critChance:Float, description:String)
	{
		this.name = name;
		this.cost = cost;
		this.physical = physical;
		this.factor = factor;
		this.critChance = critChance;
		this.description = description;
	}
}
