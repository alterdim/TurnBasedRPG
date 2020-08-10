package entities;

import flixel.FlxSprite;

class Entity extends FlxSprite
{
	public var hp:Int;
	public var atk:Int;
	public var int:Int;
	public var agi:Int;
	public var mp:Int;
	public var def:Int;

	public function new(x:Float = 0, y:Float = 0, spriteName:String, sizeX:Int = 16, sizeY:Int = 16)
	{
		super(x, y);
		loadGraphic("assets/images/" + spriteName + ".png", true, sizeX, sizeY);
	}
}
