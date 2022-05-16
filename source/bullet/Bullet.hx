package bullet;

import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.tile.FlxTilemap;
import flixel.util.FlxTimer;

class Bullet extends FlxSprite
{
	// Bullet variables
	public var SPEED:Int = 400;
	public var bulletId:Int;
	public var bouncesLeft:Int = 4;
	public var hurtOwnerTimer:FlxTimer = new FlxTimer();
	public var canHurtOwner:Bool;
	public var previousX:Float;
	public var previousY:Float;

	public function new(X:Float = 0, Y:Float = 0, ?angle:Float = 0)
	{
		// Call super
		super(X, Y);
		// Make graphic
		loadGraphic(AssetPaths.bullet__png, false, 5, 3);
	}

	public function fire(X:Float = 0, Y:Float = 0, angle:Float)
	{
		// Reset variables
		bouncesLeft = 4;
		canHurtOwner = false;

		// Start timer
		hurtOwnerTimer.start(1.5, setCanHurtOwner, 1);

		// Reset position
		var startPosition = FlxPoint.weak(X, Y).rotate(FlxPoint.weak(X, Y), angle);
		reset(startPosition.x, startPosition.y);

		// Set new angle
		setDirection(angle);
	}

	private function setDirection(angle:Float)
	{
		velocity.x = SPEED;
		velocity.y = 0;

		velocity = velocity.rotate(FlxPoint.weak(), angle);

		previousX = velocity.x;
		previousY = velocity.y;
	}

	private function setCanHurtOwner(timer:FlxTimer)
	{
		canHurtOwner = true;
	}

	public static function bounce(tilemap:FlxTilemap, bullet:Bullet)
	{
		if (bullet.justTouched(LEFT))
		{
			// Set x velocity
			bullet.velocity.x = bullet.previousX * -1;
			bullet.previousX = bullet.velocity.x;
			// Call decrement function
			bullet.decrementBounces();
		}
		if (bullet.justTouched(UP))
		{
			// Set y velocity
			bullet.velocity.y = bullet.previousY * -1;
			bullet.previousY = bullet.velocity.y;
			// Call decrement function
			bullet.decrementBounces();
		}
		if (bullet.justTouched(RIGHT))
		{
			// Set x velocity
			bullet.velocity.x = bullet.previousX * -1;
			bullet.previousX = bullet.velocity.x;
			// Call decrement function
			bullet.decrementBounces();
		}
		if (bullet.justTouched(DOWN))
		{
			// Set y velocity
			bullet.velocity.y = bullet.previousY * -1;
			bullet.previousY = bullet.velocity.y;
			// Call decrement function
			bullet.decrementBounces();
		}
	}

	private function decrementBounces()
	{
		if (bouncesLeft > 0)
		{
			// Decrement bouncesLeft
			bouncesLeft--;
		}
		else
		{
			kill();
		}
	}
}
