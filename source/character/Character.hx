/**
 * Character class
 *
 * Each character has a unique ability
 */

package character;

import bullet.Bullet;
import flixel.group.FlxGroup;
import flixel.input.gamepad.FlxGamepad;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import player.Player;

class Character extends Player
{
	// Which character and ID
	var character:String;

	// Ability variables
	private var abilityCooldown:FlxTimer = new FlxTimer();
	private var abilityCooldownLength:Int = 5;
	private var abilityReady:Bool;

	// Controller
	var gamepad:FlxGamepad;

	public function new(X:Float = 0, Y:Float = 0, chosenCharacter:String, playerId:Int = 0, playerBullets:FlxTypedGroup<Bullet>, playerGamepad:FlxGamepad)
	{
		// Assign chosen character and ID
		character = chosenCharacter;

		// Call super
		super(X, Y, playerBullets, playerId);

		// Assign gamepad
		gamepad = playerGamepad;

		// Start timer
		abilityCooldown.start(abilityCooldownLength, resetAbility, 1);

		if (character == "Navy")
		{
			// Give graphic
			loadGraphic(AssetPaths.Navy__png, true, 16, 21);
			setFacingFlip(LEFT, true, false);
			setFacingFlip(RIGHT, false, false);

			// Animation
			animation.add("navyStand", [0, 0, 0, 0, 1, 2], 8, true);
			animation.add("navyWalk", [3, 4], 4, true);
			animation.play("navyStand");
		}
		if (character == "Liz") {}
		if (character == "Wes") {}
	}

	override public function update(elapsed:Float)
	{
		// If gamepad assigned
		if (gamepad != null)
		{
			// Move gun
			moveGun(gamepad);
			if (canPlay)
			{
				// Call move function
				movePlayer(gamepad);
				// Call shoot function
				shoot(gamepad);
				// Call dash function
				dash(gamepad);
			}

			// Call character specifics
			if (character == "Navy")
			{
				// Determine animation
				if (isMoving == true)
				{
					animation.play("navyWalk");
				}
				else
				{
					animation.play("navyStand");
				}
				// Call ability function
				donAbility();
			}
			if (character == "Liz")
			{
				lizAbility();
			}
			if (character == "Wes")
			{
				wesAbility();
			}
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

	private function donAbility()
	{
		if (abilityReady && gamepad.pressed.LEFT_SHOULDER)
		{
			// Reset cooldown timer
			abilityCooldown.start(abilityCooldownLength, resetAbility, 1);

			// Turn abilityReady to false
			abilityReady = false;
		}
	}

	private function lizAbility() {}

	private function wesAbility() {}
}
