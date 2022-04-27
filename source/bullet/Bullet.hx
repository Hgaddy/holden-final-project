package bullet;

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

	public function fire(X:Float = 0, Y:Float = 0)
	{
		x = X;
		y = Y;
	}

	private function setDirection(angle)
	{
		velocity.x = SPEED;
		velocity.y = 0;
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
