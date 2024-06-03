package;

import flixel.ui.FlxButton;

class Tile extends FlxButton
{	
	/**
	 * Creates a tile (really just a button). 
	 * @param X 		The X coordinates of the button.
	 * @param Y 		The Y coordinates of the button.
	 * @param Label 	The letter that is displayed.
	 * @param OnDown 	The function called when the button is pressed.
	 */

	public function new(X:Int = 0, Y:Int = 0, Label:String, ?OnDown:Void->Void)
	{
		super(X, Y, Label, OnDown);

		width = 20;
		height = 20;
		label.alpha = 1;
		set_status(status);

		makeGraphic(Std.int(width), Std.int(height), 0);
	}
	
	public function getX():Int
	{
		return Std.int(this.x);
	}

	public function getY():Int
	{
		return Std.int(this.y);
	}
}
