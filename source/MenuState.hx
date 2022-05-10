package;

import characterSprites.CharacterSelector;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class MenuState extends FlxState
{
	var titleText:FlxText;
	var nextText:FlxText;
	var allSprites:FlxSpriteGroup;

	override public function create()
	{
		if (FlxG.sound.music == null) // don't restart the music if it's already playing
		{
			// Start music
			// FlxG.sound.playMusic(AssetPaths., 0.8, true);
		}
		// Create sprites
		allSprites = new FlxSpriteGroup();
		allSprites.add(new CharacterSelector(130, 300, Moss));
		allSprites.add(new CharacterSelector(230, 300, Navy));
		allSprites.add(new CharacterSelector(330, 300, Rose));
		allSprites.add(new CharacterSelector(430, 300, Sand));
		add(allSprites);

		// Create title
		titleText = new FlxText(20, 0, 0, "GameName", 35);
		titleText.screenCenter(X);
		add(titleText);

		// Create guidance text
		nextText = new FlxText(20, 0, 0, "Press Start", 20);
		nextText.screenCenter(XY);
		add(nextText);

		// Call super
		super.create();
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

		// Set fullscreen
		if (FlxG.gamepads.anyJustPressed(BACK))
		{
			FlxG.fullscreen = !FlxG.fullscreen;
		}
		if (FlxG.gamepads.anyJustPressed(START))
		{
			nextState();
		}
	}
}
