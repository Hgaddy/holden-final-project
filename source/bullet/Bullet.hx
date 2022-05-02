package bullet;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.tile.FlxTile;
import flixel.tile.FlxTilemap;
import flixel.util.FlxColor;

class Bullet extends FlxSprite
{
	// Bullet variables
	public static var SPEED = 250;

	private var bouncesLeft = 3;

	public function new(X:Float = 0, Y:Float = 0, ?angle:Float = 0)
	{
		// Call super
		super(X, Y);
		// Make graphic
		makeGraphic(10, 10, FlxColor.RED);

		// Set bullet direction
		setDirection(angle);
	}

	public function fire(X:Float = 0, Y:Float = 0, angle)
	{
		var startPosition = FlxPoint.weak(X + 50, Y).rotate(FlxPoint.weak(X, Y), angle);

		reset(startPosition.x, startPosition.y);
		setDirection(angle);
	}

	private function setDirection(angle:Float)
	{
		velocity.x = SPEED;
		velocity.y = 0;

		velocity = velocity.rotate(FlxPoint.weak(), angle);
	}

	public static function bounce(tilemap:FlxTilemap, bullet:Bullet)
	{
		if (bullet.justTouched(LEFT))
		{
			// Set x velocity
			bullet.velocity.x = SPEED;
			// Call decrement function
			bullet.decrementBounces();
		}
		if (bullet.justTouched(UP))
		{
			// Set y velocity
			bullet.velocity.y = SPEED;
			// Call decrement function
			bullet.decrementBounces();
		}
		if (bullet.justTouched(RIGHT))
		{
			// Set x velocity
			bullet.velocity.x = -SPEED;
			// Call decrement function
			bullet.decrementBounces();
		}
		if (bullet.justTouched(DOWN))
		{
			// Set y velocity
			bullet.velocity.y = -SPEED;
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
