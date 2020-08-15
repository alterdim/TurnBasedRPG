import flash.geom.Matrix;
import flash.geom.Point;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

using flixel.util.FlxSpriteUtil;

class ChoiceHUD extends FlxTypedGroup<FlxSprite>
{
	var screen:FlxSprite;
	var background:FlxSprite;
	var currentChoices:Array<Choice>;
	var pointer:FlxSprite;
	var debugChoice:Choice;

	public var outcome:Choice;

	var selected:Choice;
	var selectedId:Int;
	var choiceDone:Bool;

	var alpha:Float;
	var wait:Bool = true;

	public function new()
	{
		super();
		screen = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.TRANSPARENT);
		background = new FlxSprite().makeGraphic(302, 203, FlxColor.WHITE);
		background.drawRect(100, 82, 120, 300, FlxColor.BLACK);
		background.screenCenter();
		add(background);
		debugChoice = new Choice("debug", background, 0);
		currentChoices = [debugChoice];
		pointer = new FlxSprite(background.x + 10, currentChoices[0].textSprite.y + (currentChoices[0].textSprite.height / 2) - 8, AssetPaths.pointer__png);
		active = false;
		visible = false;
		add(pointer);

		forEach(function(sprite:FlxSprite)
		{
			sprite.scrollFactor.set();
			sprite.alpha = 0;
		});
	}

	public function pushChoices(newChoices:Array<String>)
	{
		choiceDone = false;
		outcome = null;
		screen.drawFrame();
		currentChoices = new Array<Choice>();
		for (i in 0...newChoices.length)
		{
			currentChoices[i] = new Choice(newChoices[i], background, i);
			add(currentChoices[i].textSprite);
		}
		visible = true;
		pointer.visible = true;
		selected = currentChoices[0];
		selectedId = 0;
		movePointer();
		FlxTween.num(0, 1, .66, {ease: FlxEase.circOut, onComplete: finishFadeIn}, updateAlpha);
	}

	function finishFadeOut(_)
	{
		active = false;
		visible = false;
	}

	function updateAlpha(alpha:Float)
	{
		this.alpha = alpha;
		forEach(function(sprite) sprite.alpha = alpha);
	}

	function finishFadeIn(_)
	{
		active = true;
		wait = false;
		pointer.visible = true;
	}

	function movePointer()
	{
		pointer.y = selected.textSprite.y + (selected.textSprite.height / 2) - 8;
	}

	override public function update(elapsed:Float)
	{
		updateKeyboardInput();
		updateTouchInput();

		super.update(elapsed);
	}

	function makeChoice()
	{
		outcome = selected;
	}

	public function terminate()
	{
		choiceDone = true;
		FlxTween.num(1, 0, .66, {ease: FlxEase.circOut, onComplete: finishFadeOut, startDelay: 1}, updateAlpha);
		return selected.textContent;
	}

	function updateTouchInput()
	{
		#if FLX_TOUCH
		for (touch in FlxG.touches.justReleased())
		{
			for (choice in currentChoices)
			{
				var text = choice.textSprite;
				if (touch.overlaps(text))
				{
					selected = choice;
					movePointer();
					makeChoice();
					return;
				}
			}
		}
		#end
	}

	function updateKeyboardInput()
	{
		#if FLX_KEYBOARD
		// setup some simple flags to see which keys are pressed.
		var up:Bool = false;
		var down:Bool = false;
		var fire:Bool = false;

		// check to see any keys are pressed and set the cooresponding flags.
		if (FlxG.keys.anyJustReleased([SPACE, X, ENTER]))
		{
			fire = true;
		}
		else if (FlxG.keys.anyJustReleased([W, UP]))
		{
			up = true;
		}
		else if (FlxG.keys.anyJustReleased([S, DOWN]))
		{
			down = true;
		}

		// based on which flags are set, do the specified action
		if (fire)
		{
			makeChoice(); // when the playerSprite chooses either option, we call this function to process their selection
		}
		else if (up || down)
		{
			// if the playerSprite presses up or down, we move the cursor up or down (with wrapping)
			if (up)
				selectedId--;
			else
				selectedId++;
			if (selectedId >= currentChoices.length)
				selectedId = 0;
			if (selectedId < 0)
				selectedId = currentChoices.length - 1;
			selected = currentChoices[selectedId];
			movePointer();
		}
		#end
	}
}

private class Choice
{
	public var textSprite:FlxText;

	public var textContent:String;

	public function new(string:String, background:FlxSprite, offset:Int)
	{
		this.textContent = string;
		this.textSprite = new FlxText(background.x + 20, background.y + 105 + 10 * offset, 85, string, 12);
	}
}
