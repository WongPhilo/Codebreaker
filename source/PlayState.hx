package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import openfl.Assets;

class PlayState extends FlxState
{
	// Private groups
	private var _tiles:Array<Tile>;
	private var _selected:Array<Tile>;
	private var digits:Array<String> = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"];

	// Buttons
	private var reset:FlxButton;
	private var submit:FlxButton;
	private var sbclear:FlxButton;
	private var delete:FlxButton;

	// Text
	private var guessed:FlxText;
	private var bullstext:FlxText;
	private var cowstext:FlxText;
	private var levtext:FlxText;
	private var overtext:FlxText;
	private var turnstext:FlxText;

	// Variables
	private var gameover:Bool;
	private var code:String;
	private var turns:Int;
	private var bulls:Int;
	private var cows:Int;
	private var sb:StringBuf;
	private var lev:Int;

	/**
	 * Creates and initializes a new game state.
	 */
	override public function create():Void
	{
		super.create();
		gameover = false;
		lev = 1;
		turns = 10;
		bulls = 0;
		cows = 0;
		_tiles = new Array<Tile>();
		_selected = new Array<Tile>();
		var tileX = 10;
		var tileY = FlxG.height - 50;
		for (v in digits)
		{
			var _tile:Tile;
			_tile = new Tile(tileX, tileY, v, null);
			_tile.onDown.callback = addLetter.bind(v, _tile);
			_tile.label.color = FlxColor.WHITE;
			_tiles.push(_tile);
			add(_tile);
			tileX += 20;
		}

		var height:Int = FlxG.height - 22;
		submit = new FlxButton(0, height, "Submit", submitCallback.bind());
		delete = new FlxButton(80, height, "Delete", deleteCallback.bind());
		sbclear = new FlxButton(160, height, "Clear", sbClearCallback.bind());
		add(submit);
		add(delete);
		add(sbclear);

		submit.color = FlxColor.RED;
		code = genCode(lev);
		sb = new StringBuf();
		guessed = new FlxText(10, 10, sb.toString(), 20);
		bullstext = new FlxText(10, 50, "Bulls: " + Std.string(bulls), 20);
		cowstext = new FlxText(10, 80, "Cows: " + Std.string(cows), 20);
		turnstext = new FlxText(10, 110, "Turns: " + Std.string(turns), 20);
		levtext = new FlxText(10, 140, "Level: " + Std.string(lev), 20);
		add(guessed);
		add(bullstext);
		add(cowstext);
		add(turnstext);
		add(levtext);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}

	/**
	 * Resets the game state, either after a game over or advancing to a new level.
	 * @param rlev 	The level that the game state is proceeding to. 1 if a reset, >1 otherwise.
	 * The length of the code that is to be cracked is (3 + rlev).
	 */
	function resetCallback(rlev:Int):Void
	{
		gameover = false;
		lev = rlev;
		turns = 10;
		bulls = 0;
		cows = 0;
		sbClearCallback();
		overtext.destroy();
		reset.destroy();
		guessed.text = sb.toString();
		guessed.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.TRANSPARENT, 2, 1);
		submit.color = FlxColor.RED;
		bullstext.text = "Bulls: " + Std.string(bulls);
		cowstext.text = "Cows: " + Std.string(cows);
		turnstext.text = "Turns: " + Std.string(turns);
		levtext.text = "Level: " + Std.string(lev);

		code = genCode(lev);
		sb = new StringBuf();
	}

	/**
	 * Submits the inputted code, and updates the # of bulls and # of cows associated with that code.
	 * Also handles the checks for game over (running out of turns), and winning (correctly guessing the code).
	 */
	function submitCallback():Void
	{
		if (gameover)
		{
			return;
		}

		if (_selected.length == code.length)
		{
			turns--;
			cows = 0;
			bulls = 0;
			for (v in 0..._selected.length)
			{
				var t = _selected[v];
				t.label.color = FlxColor.WHITE;
				var f = t.label.text;
				if (code.indexOf(f) == v)
				{
					bulls++;
				}
				else if (code.indexOf(f) != -1)
				{
					cows++;
				}
			}

			if (bulls == code.length)
			{
				gameover = true;
				overtext = new FlxText(FlxG.width / 2, 120, "You won!", 32);
				overtext.x -= overtext.width / 2;
				overtext.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.GREEN, 2, 1);
				add(overtext);
				if (lev >= 10)
				{
					reset = new FlxButton(FlxG.width / 2 - 40, 165, "Next level", resetCallback.bind(lev));
				}
				else
				{
					reset = new FlxButton(FlxG.width / 2 - 40, 165, "Next level", resetCallback.bind(lev + 1));
				}
				add(reset);
			}
			else if (turns <= 0)
			{
				gameover = true;
				overtext = new FlxText(FlxG.width / 2, 120, "Game Over!", 32);
				overtext.x -= overtext.width / 2;
				overtext.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.RED, 2, 1);
				add(overtext);
				reset = new FlxButton(FlxG.width / 2 - 40, 165, "Reset", resetCallback.bind(1));
				add(reset);
				guessed.text = Std.string(code);
				guessed.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.RED, 2, 1);
			}
			else
			{
				sb = new StringBuf();
				guessed.text = sb.toString();
				_selected = new Array<Tile>();
			}

			submit.color = FlxColor.RED;
			bullstext.text = "Bulls: " + Std.string(bulls);
			cowstext.text = "Cows: " + Std.string(cows);
			turnstext.text = "Turns: " + Std.string(turns);
		}
	}

	/**
	 * Clears the inputted code. 
	 */
	function sbClearCallback():Void
	{
		if (gameover)
		{
			return;
		}

		sb = new StringBuf();
		for (v in _selected)
		{
			v.label.color = FlxColor.WHITE;
		}
		_selected = new Array<Tile>();
		submit.color = FlxColor.RED;
		guessed.text = sb.toString();
	}

	/**
	 * Deletes the last character within the inputted string.
	 */
	function deleteCallback():Void
	{
		if (gameover)
		{
			return;
		}

		submit.color = FlxColor.RED;
		var tempstr:String = sb.toString();
		sb = new StringBuf();
		sb.addSub(tempstr, 0, tempstr.length - 1);
		var ret:Tile = _selected.pop();
		ret.label.color = FlxColor.WHITE;
		guessed.text = sb.toString();
	}

	/**
	 * Appends the selected tile to the inputted code, and prevents the tile from being selected again.
	 * @param str 	The digit selected.
	 * @param t 	The tile corresponding with said digit. 
	 */
	function addLetter(str:String, t:Tile):Void
	{
		if (gameover || _selected.contains(t) || _selected.length >= code.length)
		{
			return;
		}

		t.label.color = FlxColor.RED;
		_selected.push(t);
		if (_selected.length == code.length)
		{
			submit.color = FlxColor.GREEN;
		}
		else
		{
			submit.color = FlxColor.RED;
		}

		sb.add(str);
		guessed.text = sb.toString();
	}

	/**
	 * Generates a random code of (3 * lev) length, with no duplicate digits. 
	 * @return String	The random word that is retrieved.
	 */
	function genCode(lev:Int):String
	{
		var posdigits:Array<String> = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"];
		var bcode:StringBuf = new StringBuf();
		for (i in 0...(3 + lev))
		{
			var rand = Std.int(Math.random() * posdigits.length);
			var val = posdigits[rand];
			bcode.add(val);
			posdigits.remove(val);
		}

		return bcode.toString();
	}
}
