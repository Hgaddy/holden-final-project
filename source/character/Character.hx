/**
 * Character class
 *
 * Each character has a unique ability
 */

package character;

import bullet.Bullet;
import character.CharacterTypes;
import flixel.FlxG;
import flixel.group.FlxGroup;
import flixel.input.gamepad.FlxGamepad;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxTimer;
import player.Player;

class Character extends Player
{
	// Which character and ID
	public var character:CharacterTypes;

	// Graphic access
	public var newGraphic:FlxGraphicAsset;

	// Ability variables
	private var abilityCooldown:FlxTimer = new FlxTimer();
	private var abilityCooldownLength:Int = 5;
	private var abilityReady:Bool;

	// Controller
	var gamepad:FlxGamepad;

	// Tracking
	var alreadyPlaying:Bool = false;
	var walkSoundTimer:FlxTimer = new FlxTimer();

	public function new(X:Float = 0, Y:Float = 0, type:CharacterTypes = CharacterTypes.Moss, playerId:Int = 0, playerBullets:FlxTypedGroup<Bullet>,
			playerGamepad:FlxGamepad)
	{
		// Assign chosen character
		character = type;

		// Call super
		super(X, Y, playerBullets, playerId);

		// Get graphic
		switch (character)
		{
			case Navy:
				newGraphic = AssetPaths.Navy__png;
			case Moss:
				newGraphic = AssetPaths.Moss__png;
			case Rose:
				newGraphic = AssetPaths.Rose__png;
			case Sand:
				newGraphic = AssetPaths.Sand__png;
		}
		loadGraphic(newGraphic, true, 16, 21);

		// Make animation
		animation.add("stand", [0, 0, 0, 0, 1, 2], 8, true);
		animation.add("walk", [3, 4], 4, true);
		// Play animation
		animation.play("stand");

		// Assign gamepad
		gamepad = playerGamepad;

		// Start timer
		abilityCooldown.start(abilityCooldownLength, resetAbility, 1);
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

			// Call character ability
			switch (character)
			{
				case Navy:
					navyAbility();
				case Moss:
					mossAbility();
				case Rose:
					roseAbility();
				case Sand:
					sandAbility();
			}
		}

		// Determine animation
		if (isMoving == true)
		{
			animation.play("walk");
			if (!alreadyPlaying)
			{
				alreadyPlaying = true;
				walkSoundTimer.start(0.25, playWalkSound, 0);
			}
		}
		else
		{
			animation.play("stand");
			walkSoundTimer.cancel();
			alreadyPlaying = false;
		}

		// Call super
		super.update(elapsed);
	}

	private function playWalkSound(timer:FlxTimer)
	{
		FlxG.sound.play(AssetPaths.walkSound__wav, 0.30);
	}

	private function resetAbility(timer:FlxTimer)
	{
		abilityReady = true;
	}

	public function isAbilityReady():Bool
	{
		return abilityReady;
	}

	private function navyAbility() {}

	private function mossAbility() {}

	private function roseAbility() {}

	private function sandAbility() {}
}
