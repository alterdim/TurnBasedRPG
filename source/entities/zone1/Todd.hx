package entities.zone1;

class Todd extends Interactable
{
	var dialogueChoice:Array<String>;

	public function new(x:Int = 0, y:Int = 0)
	{
		super(x, y, "todd");
		dialogueChoice = ["Test1", "Test2", "Test3"];
		setChoices(dialogueChoice);
	}
}
