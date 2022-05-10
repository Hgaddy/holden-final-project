package;

import flixel.FlxG;
import characterSprites.CharacterTypes;
import flixel.math.FlxPoint;
import characterSprites.CharacterSelector;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.input.gamepad.FlxGamepad;
import flixel.util.FlxColor;

class CharacterState extends FlxState
{
	// Needed lists
	var allGamepads:Array<FlxGamepad> = [];
	var characterChoices:FlxGroup;

	// Num players
	var numPlayers:Int = 4;

	// Chosen characters
	private var characterTypes:Array<CharacterTypes> = CharacterTypes.createAll();
	private var characterSelectors:FlxTypedGroup<CharacterSelector>;

	override public function create()
	{
		// Call super
		super.create();

		// Fade in
		FlxG.camera.fade(FlxColor.BLACK, 0.33, true);

		// Set up choice panels
		characterSelectors = initCharacterSelectors();
		add(characterSelectors);
	}

	private function initCharacterSelectors():FlxTypedGroup<CharacterSelector> 
	{
		var result = new FlxTypedGroup<CharacterSelector>(4);
		var startingPositions:Array<FlxPoint> = [
			FlxPoint.weak(100, 100),
			FlxPoint.weak(460, 100),
			FlxPoint.weak(100, 275),
			FlxPoint.weak(460, 275)
		];
		for (i in 0...startingPositions.length) {
			result.add(
				new CharacterSelector(
					startingPositions[i].x, 
					startingPositions[i].y,
					characterTypes[i]));
		}
		return result;
	}

	private function changeSprite(changeBy:Int, characterSelector:CharacterSelector)
	{
		var currentTypeIndex = characterTypes.indexOf(characterSelector.type);
		var newTypeIndex = currentTypeIndex + changeBy;

		// handle wrapping
		newTypeIndex = newTypeIndex % characterTypes.length;
		while (newTypeIndex < 0) // This is kinda overkill, but it handles weird cases successfully
		{
			newTypeIndex += characterTypes.length;
		}

		characterSelector.type = characterTypes[newTypeIndex];
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
			changeSprite(-1, characterSelectors.members[0]);
		}
		if (FlxG.gamepads.anyJustPressed(DPAD_RIGHT))
		{
			changeSprite(1, characterSelectors.members[0]);
		}

		// Set fullscreen
		if (FlxG.gamepads.anyJustPressed(BACK))
		{
			FlxG.fullscreen = !FlxG.fullscreen;
		}
	}
}
