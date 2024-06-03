package;

import flixel.ui.FlxButton;
import flash.display.BlendMode;
import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;

class MenuState extends FlxState
{
	private var titleText:FlxText;
	private var playButton:FlxButton;
	
	/**
	 * Creates the title menu screen. 
	 */
	override public function create():Void
	{
		FlxG.cameras.bgColor = FlxColor.BLACK;
		FlxG.timeScale = 1;

		var playButton = new FlxButton(0, 0, "Play", startGame);
		playButton.screenCenter();
		createTitle();
		add(playButton);

		super.create();
	}

	function startGame():Void
	{
		FlxG.switchState(PlayState.new);
	}

	override public function update(elapsed:Float):Void
	{	
		super.update(elapsed);
	}

	/**
	 * Creates the title text.
	 */
	private function createTitle():Void
	{
		titleText = new FlxText(FlxG.width / 2, 40, "Codebreaker", 32);
		titleText.x -= titleText.width / 2;
		titleText.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.GRAY, 2, 1);
		add(titleText);
	}
}