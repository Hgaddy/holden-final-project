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
import flixel.group.FlxGroup;
import flixel.group.FlxSpriteGroup;
import flixel.input.gamepad.FlxGamepad;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

class Player extends FlxSprite
{
	// Player variables
	public var BASEVEL:Int = 200;
	public var BASEDRAG = new FlxPoint(2000, 2000);
	public var MAXHEALTH:Int = 3;
	public var playerId:Int;
	public var isMoving:Bool;

	// Shoot variables
	public var bullets:FlxTypedGroup<Bullet>;
	public var shootCooldown:FlxTimer = new FlxTimer();
	public var canShoot:Bool = true;

	// Dash variables
	public var dashCooldown:FlxTimer = new FlxTimer();
	public var speedChange:FlxTimer = new FlxTimer();
	public var canDash:Bool = true;

	public function new(X:Float = 0, Y:Float = 0, playerBullets:FlxTypedGroup<Bullet>, playerId:Int)
	{
		// Call super
		super(X, Y);

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
	}

	private function movePlayerGamepad(gamepad:FlxGamepad)
	{
		// If pressed
		if (gamepad.pressed.DPAD_UP)
		{
			velocity.y = -BASEVEL;
		}

		if (gamepad.pressed.DPAD_LEFT)
		{
			velocity.x = -BASEVEL;

			// Set facing
			facing = LEFT;
		}

		if (gamepad.pressed.DPAD_DOWN)
		{
			velocity.y = BASEVEL;
		}

		if (gamepad.pressed.DPAD_RIGHT)
		{
			velocity.x = BASEVEL;

			// Set facing
			facing = RIGHT;
		}

		// If released
		if (gamepad.justReleased.DPAD_UP || gamepad.justReleased.DPAD_DOWN)
		{
			velocity.y = 0;
		}

		if (gamepad.justReleased.DPAD_LEFT || gamepad.justReleased.DPAD_RIGHT)
		{
			velocity.x = 0;
		}

		// If both pressed
		if (gamepad.pressed.DPAD_UP && gamepad.pressed.DPAD_DOWN)
		{
			velocity.y = 0;
		}

		if (gamepad.pressed.DPAD_LEFT && gamepad.pressed.DPAD_RIGHT)
		{
			velocity.x = 0;
		}

		if (velocity.x == 0 && velocity.y == 0)
		{
			isMoving = false;
		}
		else
		{
			isMoving = true;
		}
	}

	private function resetShoot(timer:FlxTimer)
	{
		canShoot = true;
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
			var positionX:Float = getMidpoint().x;
			var positionY:Float = getMidpoint().y;
			var angle:Float = gamepad.getAnalogAxes(RIGHT_ANALOG_STICK).angleBetween(FlxPoint.weak()) + 90;

			// Recycle bullet
			var recycled:Bullet = bullets.add(bullets.recycle(Bullet));
			recycled.bulletId = playerId;

			// Call fire function
			recycled.fire(positionX, positionY, angle);

			// Play sound effect
			FlxG.sound.play(AssetPaths.gunShot__wav, 100);

			// Flip canShoot
			canShoot = false;

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

	private function resetDash(timer:FlxTimer)
	{
		canDash = true;
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

			// Toggle canDash
			canDash = false;
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
			// Kill bullet
			bullet.kill();
		}
		if (bullet.bulletId != player.playerId)
		{
			// Kill player
			player.kill();
			// Kill bullet
			bullet.kill();
		}
	}
}
