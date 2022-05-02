/**
 * Character class: Don
 *
 * Special ability: Undecided
 */

package character;

import flixel.input.gamepad.FlxGamepad;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import player.Player;

class Don extends Player
{
	// Ability variables
	private var abilityCooldown:FlxTimer = new FlxTimer();
	private var abilityCooldownLength:Int = 5;
	private var abilityReady:Bool;

	// Controller
	var gamepad:FlxGamepad;

	public function new(X:Float = 0, Y:Float = 0, playerGamepad:FlxGamepad)
	{
		// Call super
		super(X, Y);

		// Assign gamepad
		gamepad = playerGamepad;

		// Start timer
		abilityCooldown.start(abilityCooldownLength, resetAbility, 1);

		// Give graphic
		loadGraphic(AssetPaths.DonStanding__png, true);
		setFacingFlip(LEFT, true, false);
		setFacingFlip(RIGHT, false, false);

		// Animation
		animation.add("Stand", [0, 1], 2, true);
		animation.play("Stand");
	}

	override public function update(elapsed:Float)
	{
		// If gamepad assigned
		if (gamepad != null)
		{
			// Call move function
			movePlayerGamepad(gamepad);
			// Call shoot function
			shoot(gamepad);
			// Call dash function
			dash(gamepad);
			// Call ability function
			useAbility();
		}

		// Call super
		super.update(elapsed);
	}

	private function resetAbility(timer:FlxTimer)
	{
		abilityReady = true;
	}

	public function isAbilityReady():Bool
	{
		return abilityReady;
	}

	override function useAbility()
	{
		if (abilityReady && gamepad.pressed.LEFT_SHOULDER)
		{
			// Reset cooldown timer
			abilityCooldown.start(abilityCooldownLength, resetAbility, 1);

			// Turn abilityReady to false
			abilityReady = false;
		}
	}
}
