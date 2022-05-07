package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.system.frontEnds.HTML5FrontEnd.FlxIOSDevice;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class StartState extends FlxState
{
	var titleText:FlxText;
	var nextText:FlxText;

	override public function create()
	{
		if (FlxG.sound.music == null) // don't restart the music if it's already playing
		{
			// Start music
			// FlxG.sound.playMusic(AssetPaths., 0.8, true);
		}

		// Create title
		titleText = new FlxText(20, 0, 0, "GameName", 35);
		titleText.screenCenter(X);
		add(titleText);

		// Create guidance text
		nextText = new FlxText(20, 0, 0, "Press Start", 20);
		nextText.screenCenter(XY);
		add(nextText);

		super.create();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		// Set fullscreen
		if (FlxG.gamepads.anyJustPressed(BACK))
		{
			FlxG.fullscreen = !FlxG.fullscreen;
		}
		// Load next state
		if (FlxG.gamepads.anyJustPressed(START))
		{
			FlxG.camera.fade(FlxColor.BLACK, 0.33, false, function()
			{
				FlxG.sound.music.stop();
				FlxG.switchState(new PlayState());
			});
		}
	}
}
