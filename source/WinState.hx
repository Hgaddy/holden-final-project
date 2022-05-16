package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.system.System;

class WinState extends FlxState
{
	// All text
	private var winText:FlxText;
	private var susText:FlxText;
	private var restartText:FlxText;
	private var exitText:FlxText;

	// Tracking variable
	private var winningPlayer:Int;

	public function new(winningPlayer:Int)
	{
		// Call super
		super();
		// Assign incoming variable
		this.winningPlayer = winningPlayer;
	}

	override public function create()
	{
		// Call super
		super.create();

		// Play music
		FlxG.sound.playMusic(AssetPaths.winMusic__wav, 0.8, true);

		// Fade in
		FlxG.camera.fade(FlxColor.BLACK, 0.33, true);

		// Create winText
		winText = new FlxText(0, 0, 0, "Player " + winningPlayer + " Wins!", 45);
		winText.screenCenter(XY);
		add(winText);

		// Create susText
		susText = new FlxText(0, FlxG.height / 2 + 25, 0, "Was it worth it?", 10);
		susText.screenCenter(X);
		add(susText);

		// Create restartText
		restartText = new FlxText(0, FlxG.height - 70, 0, "Press Start to Restart", 25);
		restartText.screenCenter(X);
		add(restartText);

		// Create exitText
		exitText = new FlxText(0, FlxG.height - 40, 0, "Press B to Exit", 25);
		exitText.screenCenter(X);
		add(exitText);
	}

	override public function update(elapsed:Float)
	{
		// Check if Start pressed
		if (FlxG.gamepads.anyJustPressed(START))
		{
			// Fade to next
			FlxG.camera.fade(FlxColor.BLACK, 0.33, false, function()
			{
				// Stop music
				FlxG.sound.music.stop();
				// Switch state
				FlxG.switchState(new MenuState());
			});
		}
		// Set fullscreen
		if (FlxG.gamepads.anyJustPressed(BACK))
		{
			FlxG.fullscreen = !FlxG.fullscreen;
		}
		// Check if B pressed
		if (FlxG.gamepads.anyJustPressed(B))
		{
			System.exit(0);
		}
	}
}
