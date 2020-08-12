package entities;

class Interactable extends Entity
{
	var choices:Array<String>;

	public function new(x:Int = 0, y:Int = 0, spritename:String)
	{
		super(x, y, spritename);
	}

	public function getChoices()
	{
		return choices;
	}

	function setChoices(newChoices:Array<String>)
	{
		this.choices = newChoices;
	}
}
