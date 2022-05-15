/**
 * Basic player mechanics implementation
 * 
 * May be changed in the future
 */

package player;

import bullet.Bullet;
import character.Character;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.effects.FlxTrail;
import flixel.group.FlxGroup;
import flixel.group.FlxSpriteGroup;
import flixel.input.gamepad.FlxGamepad;
import flixel.math.FlxPoint;
import flixel.ui.FlxBar;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

class Player extends FlxSprite
{
	// Player variables
	public var canPlay:Bool = false;
	public var BASEVEL:Int = 200;
	public var BASEDRAG = new FlxPoint(2000, 2000);
	public var MAXHEALTH:Int = 3;
	public var playerId:Int;
	public var isMoving:Bool;

	// Cooldown bar variables
	public var abilityBar:FlxBar;
	public var abilityValue:String;
	public var dashBar:FlxBar;
	public var dashValue:String;
	public var shotBar:FlxBar;
	public var shotValue:String;

	// Gun variables
	public var gun:FlxSprite;

	private var gunPreviousX:Float;
	private var gunPreviousY:Float;

	// Shoot variables
	public var bullets:FlxTypedGroup<Bullet>;
	public var shootCooldown:FlxTimer = new FlxTimer();
	public var canShoot:Bool = true;

	// Dash variables
	public var dashCooldown:FlxTimer = new FlxTimer();
	public var speedChange:FlxTimer = new FlxTimer();
	public var trailOffTimer:FlxTimer = new FlxTimer();
	public var canDash:Bool = true;
	public var trail:FlxTrail;

	public function new(X:Float = 0, Y:Float = 0, playerBullets:FlxTypedGroup<Bullet>, playerId:Int)
	{
		// Call super
		super(X, Y);

		// Set up gun
		gun = new FlxSprite(this.x, this.y, AssetPaths.gun__png);
		gun.setFacingFlip(LEFT, false, true);
		gun.setFacingFlip(RIGHT, false, false);

		// Change player variables
		this.playerId = playerId;
		this.drag = BASEDRAG;

		// Create bullet list
		bullets = playerBullets;
	}

	override public function update(elapsed:Float)
	{
		// Call super
		super.update(elapsed);
		// update bars
		abilityBar.updateBar();
		dashBar.updateBar();
		shotBar.updateBar();
	}

	private function movePlayer(gamepad:FlxGamepad)
	{
		var angle:Float = gamepad.getAnalogAxes(LEFT_ANALOG_STICK).angleBetween(FlxPoint.weak()) + 90;
		if (!gamepad.getAnalogAxes(LEFT_ANALOG_STICK).isZero())
		{
			// Set facing
			if (angle > 90 && angle <= 270)
			{
				facing = LEFT;
			}
			else
			{
				facing = RIGHT;
			}
			// Set velocity
			velocity.x = BASEVEL * gamepad.getAnalogAxes(LEFT_ANALOG_STICK).length;
			velocity.y = 0;
			velocity = velocity.rotate(FlxPoint.weak(), angle);

			// Set isMoving
			isMoving = true;
		}
		else
		{
			// Set velocity
			velocity.x = 0;
			velocity.y = 0;

			// Set isMoving
			isMoving = false;
		}
	}

	private function moveGun(gamepad:FlxGamepad)
	{
		if (!gamepad.getAnalogAxes(RIGHT_ANALOG_STICK).isZero())
		{
			// Rotate gun
			gun.angle = gamepad.getAnalogAxes(RIGHT_ANALOG_STICK).angleBetween(FlxPoint.weak()) + 90;
		}
		// Set position
		gun.x = x + 2 + (10 * gamepad.getXAxis(RIGHT_ANALOG_STICK));
		gun.y = y + 12 + (10 * gamepad.getYAxis(RIGHT_ANALOG_STICK));
		gun.velocity = velocity;

		// Set facing
		if (gun.angle > 90 && gun.angle < 270)
		{
			gun.facing = LEFT;
		}
		if (gun.angle < 90 || gun.angle > 270)
		{
			gun.facing = RIGHT;
		}
	}

	private function resetShoot(timer:FlxTimer)
	{
		canShoot = true;
		shotValue = "100";
	}

	public function isShootReady():Bool
	{
		return canShoot;
	}

	private function shoot(gamepad:FlxGamepad)
	{
		if (canShoot && gamepad.pressed.RIGHT_SHOULDER)
		{
			// Position and angle variables
			var positionX:Float = x + 5;
			var positionY:Float = y + 12;
			var angle:Float = gun.angle;

			// Recycle bullet
			var recycled:Bullet = bullets.add(bullets.recycle(Bullet));
			recycled.bulletId = playerId;

			// Call fire function
			recycled.fire(positionX, positionY, angle);

			// Play sound effect
			FlxG.sound.play(AssetPaths.gunShot__wav, 100);

			// Flip canShoot
			canShoot = false;

			// Set bar value
			shotValue = "0";

			// Reset shootCooldown
			shootCooldown.start(.25, resetShoot, 1);
		}
	}

	private function resetSPEED(timer:FlxTimer)
	{
		BASEVEL = 200;
	}

	private function boostSPEED()
	{
		// Change speed
		BASEVEL = 1000;

		// Start timer
		speedChange.start(0.08, resetSPEED, 1);
	}

	public function trailOn()
	{
		trail.revive();
		trail.resetTrail();
	}

	private function trailOff(timer:FlxTimer)
	{
		trail.kill();
	}

	private function resetDash(timer:FlxTimer)
	{
		canDash = true;
		dashValue = "100";
	}

	public function isDashReady():Bool
	{
		return canDash;
	}

	private function dash(gamepad:FlxGamepad)
	{
		if (canDash && gamepad.justPressed.A)
		{
			// Call boostSPEED
			boostSPEED();
			// Start trail
			trailOn();
			// Turn trail off timer
			trailOffTimer.start(0.08, trailOff, 1);

			// Toggle canDash
			canDash = false;
			// Set bar value
			dashValue = "0";
			// Reset dashCooldown
			dashCooldown.start(2, resetDash, 1);
		}
	}

	public static function overlapsWithBullet(player:Player, bullet:Bullet)
	{
		if (bullet.bulletId == player.playerId && bullet.canHurtOwner)
		{
			// Kill player
			player.kill();
			// Kill player gun
			player.gun.kill();
			// Kill bullet
			bullet.kill();
		}
		if (bullet.bulletId != player.playerId)
		{
			// Kill player
			player.kill();
			// Kill player gun
			player.gun.kill();
			// Kill bullet
			bullet.kill();
		}
	}
}
