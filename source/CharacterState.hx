package;

import character.CharacterSelector;
import character.CharacterTypes;
import flixel.FlxG;
import flixel.FlxState;
import flixel.addons.display.FlxBackdrop;
import flixel.group.FlxGroup;
import flixel.input.gamepad.FlxGamepad;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class CharacterState extends FlxState
{
	// Background
	var backdrop:FlxBackdrop;
	var text:FlxText;

	// Needed lists
	private var allGamepads:Array<FlxGamepad> = [];
	private var arePlayersReady:Array<Int> = [0, 0, 0, 0];

	// Num players
	var numPlayers:Int = 0;

	// Chosen characters
	private var characterTypes:Array<CharacterTypes> = CharacterTypes.createAll();
	private var characterChoices:Array<CharacterTypes> = [];
	private var characterSelectors:FlxTypedGroup<CharacterSelector>;

	override public function create()
	{
		// Call super
		super.create();

		// Background
		backdrop = new FlxBackdrop(AssetPaths.MenuBackground__png, 1, 0, true, false, 0, 0);
		backdrop.velocity.set(-100, 0);
		add(backdrop);

		// Create text
		text = new FlxText(0, 10, 0, "Choose Your Character", 45);
		text.screenCenter(X);
		add(text);

		// Fade in
		FlxG.camera.fade(FlxColor.BLACK, 0.33, true);

		// Set up controllers
		initControllers();

		// Set up numPlayers
		initNumPlayers();

		// Set up choice panels
		characterSelectors = initCharacterSelectors();
		add(characterSelectors);
	}

	private function initControllers()
	{
		for (i in 0...3)
		{
			allGamepads.push(FlxG.gamepads.getByID(i));
		}
	}

	private function initNumPlayers()
	{
		for (i in 0...3)
		{
			if (allGamepads[i] != null)
			{
				// Increment numPlayers
				numPlayers++;
			}
			else
			{
				// Leave loop
				break;
			}
		}
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
		for (i in 0...numPlayers)
		{
			result.add(new CharacterSelector(startingPositions[i].x, startingPositions[i].y, characterTypes[i]));
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

	private function lockChoice(ID:Int, characterSelector:CharacterSelector)
	{
		characterChoices[ID] = characterSelector.type;
		arePlayersReady[ID] = 1;
	}

	private function undoChoice(ID:Int)
	{
		arePlayersReady[ID] = 0;
	}

	private function nextState()
	{
		for (i in 0...numPlayers)
		{
			if (arePlayersReady[i] == 1)
			{
				continue;
			}
			else
			{
				return;
			}
		}
		// Stop music
		FlxG.sound.music.stop();
		// Fade to next
		FlxG.camera.fade(FlxColor.BLACK, 0.33, false, function()
		{
			// FlxG.sound.music.stop();
			// FlxG.switchState(new PlayState());
			FlxG.switchState(new PlayState(allGamepads, characterChoices, numPlayers));
		});
	}

	override public function update(elapsed:Float)
	{
		// Call super
		super.update(elapsed);

		// Call change function
		for (i in 0...numPlayers)
		{
			// Check left
			if (allGamepads[i].justPressed.DPAD_LEFT && arePlayersReady[i] != 1)
			{
				changeSprite(-1, characterSelectors.members[i]);
			}
			// Check right
			if (allGamepads[i].justPressed.DPAD_RIGHT && arePlayersReady[i] != 1)
			{
				changeSprite(1, characterSelectors.members[i]);
			}
			// If A pressed
			if (allGamepads[i].justPressed.A)
			{
				lockChoice(i, characterSelectors.members[i]);
			}
			// If B pressed
			if (allGamepads[i].justPressed.B)
			{
				undoChoice(i);
			}
		}

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
