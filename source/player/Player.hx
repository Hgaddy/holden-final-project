/**
 * Basic player mechanics implementation
 * 
 * May be changed in the future
 */

package player;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.input.gamepad.FlxGamepad;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;

class Player extends FlxSprite
{
	// Player variables
	public var BASEACCEL:Int = 800;
	public var BASEDRAG = new FlxPoint(1500, 1500);
	public var MAXSPEED = new FlxPoint(400, 400);
	public var MAXHEALTH:Int = 3;

	// Controller
	var gamepad:FlxGamepad;

	public function new(X:Float = 0, Y:Float = 0, playerGamepad:FlxGamepad)
	{
		// Call super
		super(X, Y);

		// Set player controller
		gamepad = playerGamepad;

		// Change player variables
		this.maxVelocity = MAXSPEED;
		this.drag = BASEDRAG;

		// Give graphic
		makeGraphic(20, 20, FlxColor.WHITE);
	}

	override public function update(elapsed:Float)
	{
		// If gamepad assigned
		if (gamepad != null)
		{
			// Call move function
			movePlayerGamepad(gamepad);
			// Call shoot function
			shoot();
		}

		// Call super
		super.update(elapsed);
	}

	public function movePlayerGamepad(gamepad:FlxGamepad)
	{
		// If pressed
		if (gamepad.pressed.DPAD_UP)
		{
			acceleration.y = -BASEACCEL;
		}

		if (gamepad.pressed.DPAD_LEFT)
		{
			acceleration.x = -BASEACCEL;
		}

		if (gamepad.pressed.DPAD_DOWN)
		{
			acceleration.y = BASEACCEL;
		}

		if (gamepad.pressed.DPAD_RIGHT)
		{
			acceleration.x = BASEACCEL;
		}

		// If released
		if (gamepad.justReleased.DPAD_UP || gamepad.justReleased.DPAD_DOWN)
		{
			acceleration.y = 0;
		}

		if (gamepad.justReleased.DPAD_LEFT || gamepad.justReleased.DPAD_RIGHT)
		{
			acceleration.x = 0;
		}

		// If both pressed
		if (gamepad.pressed.DPAD_UP && gamepad.pressed.DPAD_DOWN)
		{
			acceleration.y = 0;
		}

		if (gamepad.pressed.DPAD_LEFT && gamepad.pressed.DPAD_RIGHT)
		{
			acceleration.x = 0;
		}
	}

	private function shoot() {}
}
