package;

import characterSprites.MossSprite;
import characterSprites.NavySprite;
import characterSprites.RoseSprite;
import characterSprites.SandSprite;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.input.gamepad.FlxGamepad;
import flixel.util.FlxColor;

class CharacterState extends FlxState
{
	// Needed lists
	var allGamepads:Array<FlxGamepad> = [];
	var characterChoices:FlxGroup;

	// Sprite lists
	var allCharacterPositions:Array<Int>;

	// Num players
	var numPlayers:Int = 4;

	// Chosen characters
	var character1:String;
	var character1Sprite:FlxSprite;
	var character2:String;
	var character2Sprite:FlxSprite;
	var character3:String;
	var character3Sprite:FlxSprite;
	var character4:String;
	var character4Sprite:FlxSprite;

	override public function create()
	{
		// Call super
		super.create();

		// Fade in
		FlxG.camera.fade(FlxColor.BLACK, 0.33, true);

		// Set up choice panels
		allCharacterPositions = [0, 1, 2, 3];
		character1Sprite = new NavySprite(100, 100);
		add(character1Sprite);
		character2Sprite = new RoseSprite(460, 100);
		add(character2Sprite);
		character3Sprite = new MossSprite(100, 275);
		add(character3Sprite);
		character4Sprite = new SandSprite(460, 275);
		add(character4Sprite);
	}

	private function changeSprite(direction:Int, sprite:FlxSprite, position:Int)
	{
		// Which character
		var whichSprite:FlxSprite = sprite;
		var whichPosition:Int = position;
		// Update characterPosition
		if (direction == -1)
		{
			allCharacterPositions[whichPosition]--;
		}
		else
		{
			allCharacterPositions[whichPosition]++;
		}
		// If outside of range
		if (allCharacterPositions[whichPosition] == -1)
		{
			allCharacterPositions[whichPosition] = 3;
		}
		if (allCharacterPositions[whichPosition] == 4)
		{
			allCharacterPositions[whichPosition] = 0;
		}

		// Kill old instances
		whichSprite.kill();
		// Add new sprite
		if (allCharacterPositions[whichPosition] == 3)
		{
			whichSprite = new SandSprite(findXPosition(whichPosition), findYPosition(whichPosition));
			whichSprite.revive();
			add(whichSprite);
			return;
		}
		if (allCharacterPositions[whichPosition] == 2)
		{
			whichSprite = new MossSprite(findXPosition(whichPosition), findYPosition(whichPosition));
			whichSprite.revive();
			add(whichSprite);
			return;
		}
		if (allCharacterPositions[whichPosition] == 1)
		{
			whichSprite = new RoseSprite(findXPosition(whichPosition), findYPosition(whichPosition));
			whichSprite.revive();
			add(whichSprite);
			return;
		}
		if (allCharacterPositions[whichPosition] == 0)
		{
			whichSprite = new NavySprite(findXPosition(whichPosition), findYPosition(whichPosition));
			whichSprite.revive();
			add(whichSprite);
			return;
		}
	}

	private function findXPosition(positionX:Int)
	{
		var result:Int = 0;
		switch (positionX)
		{
			case 0:
				result = 100;
			case 1:
				result = 460;
			case 2:
				result = 100;
			case 3:
				result = 460;
		}
		return result;
	}

	private function findYPosition(positionY:Int)
	{
		var result:Int = 0;
		switch (positionY)
		{
			case 0:
				result = 100;
			case 1:
				result = 100;
			case 2:
				result = 275;
			case 3:
				result = 275;
		}
		return result;
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

		// Call change function
		if (FlxG.gamepads.anyJustPressed(DPAD_LEFT))
		{
			changeSprite(-1, character1Sprite, 0);
		}
		if (FlxG.gamepads.anyJustPressed(DPAD_RIGHT))
		{
			changeSprite(1, character1Sprite, 0);
		}

		// Set fullscreen
		if (FlxG.gamepads.anyJustPressed(BACK))
		{
			FlxG.fullscreen = !FlxG.fullscreen;
		}
	}
}
