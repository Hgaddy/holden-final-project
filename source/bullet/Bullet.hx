package bullet;

import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.FlxSprite;
import flixel.util.FlxColor;

class Bullet extends FlxSprite
{
	// Bullet variables
	public static var SPEED = 350;

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

	public function bounce(bounceDirection:Float = 0)
	{
		if (bounceDirection == 0)
		{
			// Flip x velocity
			velocity.x = velocity.x * -1;
			// Call decrement function
			decrementBounces();
		}
		else
		{
			// Flip y velocity
			velocity.y = velocity.y * -1;
			// Call decrement function
			decrementBounces();
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
