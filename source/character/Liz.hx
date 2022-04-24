/**
 * Character class: Liz
 *
 * Special ability: Block an incoming projectile
 */

package character;

import flixel.input.gamepad.FlxGamepad;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import player.Player;

class Liz extends Player
{
	private var abilityCooldown:FlxTimer = new FlxTimer();
	private var abilityCooldownLength:Int = 5;
	private var abilityReady:Bool;

	public function new(X:Float = 0, Y:Float = 0, playerGamepad:FlxGamepad)
	{
		// Call super
		super(X, Y, playerGamepad, "LIZ");

		// Start timer
		abilityCooldown.start(abilityCooldownLength, resetAbility, 1);

		// Give graphic
		makeGraphic(20, 20, FlxColor.WHITE);
	}

	override public function update(elapsed:Float)
	{
		// Check if ability is ready
		if (isAbilityReady() || gamepad.justPressed.LEFT_TRIGGER_BUTTON)
		{
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

	private function useAbility()
	{
		// Reset cooldown timer
		abilityCooldown.start(abilityCooldownLength, resetAbility, 1);

		// Turn abilityReady to false
		abilityReady = false;
	}
}
