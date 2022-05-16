package;

import character.CharacterSelector;
import flixel.FlxG;
import flixel.FlxState;
import flixel.addons.display.FlxBackdrop;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.system.System;

class MenuState extends FlxState
{
	// Background
	var backdrop:FlxBackdrop;

	// Music start timer
	var musicStartTimer:FlxTimer = new FlxTimer();

	// Text
	var titleText:FlxText;
	var nextText:FlxText;

	// Sprites
	var allSprites:FlxSpriteGroup;

	override public function create()
	{
		// Background
		backdrop = new FlxBackdrop(AssetPaths.MenuBackground__png, 1, 0, true, false, 0, 0);
		backdrop.velocity.set(-100, 0);
		add(backdrop);

		// Start music after delay
		musicStartTimer.start(0.48, playMusic, 1);

		// Create sprites
		allSprites = new FlxSpriteGroup();
		allSprites.add(new CharacterSelector(FlxG.width / 2 - 190, 300, Moss));
		allSprites.add(new CharacterSelector(FlxG.width / 2 - 90, 300, Navy));
		allSprites.add(new CharacterSelector(FlxG.width / 2 + 10, 300, Rose));
		allSprites.add(new CharacterSelector(FlxG.width / 2 + 110, 300, Sand));
		add(allSprites);

		// Create title
		titleText = new FlxText(30, 0, 0, "Bounce Bros", 35);
		titleText.screenCenter(X);
		add(titleText);

		// Create guidance text
		nextText = new FlxText(20, 0, 0, "Press Start", 20);
		nextText.screenCenter(XY);
		add(nextText);

		// Call super
		super.create();
	}

	private function playMusic(timer:FlxTimer)
	{
		FlxG.sound.playMusic(AssetPaths.menuMusic__wav, 0.8, true);
	}

	private function nextState()
	{
		FlxG.camera.fade(FlxColor.BLACK, 0.33, false, function()
		{
			// FlxG.sound.music.stop();
			FlxG.switchState(new CharacterState());
		});
	}

	override public function update(elapsed:Float)
	{
		// Call super
		super.update(elapsed);

		// Check if Start pressed
		if (FlxG.gamepads.anyJustPressed(START))
		{
			nextState();
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
