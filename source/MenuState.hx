package;

import characterSprites.MossSprite;
import characterSprites.NavySprite;
import characterSprites.RoseSprite;
import characterSprites.SandSprite;
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
		allSprites.add(new NavySprite(130, 300));
		allSprites.add(new RoseSprite(230, 300));
		allSprites.add(new MossSprite(330, 300));
		allSprites.add(new SandSprite(430, 300));
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
			FlxG.switchState(new PlayState());
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
