package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.input.gamepad.FlxGamepad;
import flixel.input.gamepad.FlxGamepadManager;
import lime.ui.Gamepad;
import player.Player;

class PlayState extends FlxState
{
	// Player variables
	var player1:Player;
	var player2:Player;

	// Controller variables
	var gamepad1:FlxGamepad;
	var gamepad2:FlxGamepad;

	override public function create()
	{
		super.create();

		// Get gamepads
		gamepad1 = FlxG.gamepads.getByID(0);
		gamepad2 = FlxG.gamepads.getByID(1);

		// Create player
		player1 = new Player(FlxG.width / 2 - 200, FlxG.height / 2, gamepad1);
		player2 = new Player(FlxG.width / 2 + 200, FlxG.height / 2, gamepad2);

		// Add player
		add(player1);
		add(player2);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
