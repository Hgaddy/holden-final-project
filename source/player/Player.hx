/**
 * Basic player mechanics implementation
 * 
 * May be changed in the future
 */

package player;

import bullet.Bullet;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.effects.FlxTrail;
import flixel.group.FlxGroup;
import flixel.input.gamepad.FlxGamepad;
import flixel.math.FlxPoint;
import flixel.ui.FlxBar;
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
	public var isDashing:Bool;

	// Cooldown bar variables
	public var dashBar:FlxBar;
	public var dashValue:Int = 100;
	public var shotBar:FlxBar;
	public var shotValue:Int = 100;

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
		setFacingFlip(LEFT, true, false);
		setFacingFlip(RIGHT, false, false);

		// Create bullet list
		bullets = playerBullets;
	}

	override public function update(elapsed:Float)
	{
		// Call super
		super.update(elapsed);
	}

	private function movePlayer(gamepad:FlxGamepad)
	{
		var angle:Float = gamepad.getAnalogAxes(LEFT_ANALOG_STICK).angleBetween(FlxPoint.weak()) + 90;
		if (!gamepad.getAnalogAxes(LEFT_ANALOG_STICK).isZero())
		{
			// Set facing
			if (angle > 90 && angle < 270)
			{
				facing = LEFT;
			}
			if (angle < 90 || angle > 270)
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
		shotValue = 1;
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
			shotValue = 0;

			// Reset shootCooldown
			shootCooldown.start(.75, resetShoot, 1);
		}
	}

	private function resetSPEED(timer:FlxTimer)
	{
		// Toggle isDashing
		isDashing = false;
		// Reset speed
		BASEVEL = 200;
	}

	private function boostSPEED()
	{
		// Toggle isDashing
		isDashing = true;
		// Change speed
		BASEVEL = BASEVEL * 5;
		// Start timer 0.08
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
		dashValue = 1;
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
			dashValue = 0;
			// Reset dashCooldown
			dashCooldown.start(1.75, resetDash, 1);
		}
	}

	public static function overlapsWithBullet(player:Player, bullet:Bullet)
	{
		if (player.isDashing)
		{
			bullet.kill();
			return;
		}
		if (bullet.bulletId == player.playerId && bullet.canHurtOwner)
		{
			// Kill player
			player.kill();
			// Kill player gun
			player.gun.kill();
			// Kill bars
			player.dashBar.kill();
			player.shotBar.kill();
			// Kill bullet
			bullet.kill();
			FlxG.sound.play(AssetPaths.deathSound__wav, 0.80);
		}
		if (bullet.bulletId != player.playerId)
		{
			// Kill player
			player.kill();
			// Kill player gun
			player.gun.kill();
			// Kill bars
			player.dashBar.kill();
			player.shotBar.kill();
			// Kill bullet
			bullet.kill();
			FlxG.sound.play(AssetPaths.deathSound__wav, 0.80);
		}
	}

	public static function overlapsWithPlayer(player1:Player, player2:Player)
	{
		if (player1.isDashing && player2.isDashing)
		{
			return;
		}
		if (player1.isDashing)
		{
			// Kill player 2
			player2.kill();
			player2.gun.kill();
			// Kill player 2 bars
			player2.dashBar.kill();
			player2.shotBar.kill();

			return;
		}
		if (player2.isDashing)
		{
			// Kill player 1
			player1.kill();
			player1.gun.kill();
			// Kill player 1 bars
			player1.dashBar.kill();
			player1.shotBar.kill();

			return;
		}
	}
}
