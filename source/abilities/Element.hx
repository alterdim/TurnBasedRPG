package abilities;

import entities.Entity;

class Element
{
	public static var NONE = new Element("None", FIRE, FIRE);
	public static var FIRE = new Element("Fire", WATER, LIGHT);
	public static var WATER = new Element("Water", EARTH, FIRE);
	public static var EARTH = new Element("Earth", WIND, WATER);
	public static var WIND = new Element("Wind", DARK, EARTH);
	public static var DARK = new Element("Dark", LIGHT, WIND);
	public static var LIGHT = new Element("Light", FIRE, DARK);

	var name:String;
	var resistance:Element;
	var weakness:Element;

	public function new(name:String, weakness:Element, resistance:Element)
	{
		this.name = name;
		this.weakness = weakness;
		this.resistance = resistance;
	}

	public function getFactor(target:Entity)
	{
		return target.resistances[this];
	}
}
