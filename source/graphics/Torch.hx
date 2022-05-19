package graphics;

import flixel.FlxSprite;

class Torch extends FlxSprite
{
	private var direction:Int;

	public function new(X:Float = 0, Y:Float = 0, direction:Int)
	{
		// Call super
		super(X, Y);

		// Set direction
		this.direction = direction;

		// Setup facing
		setFacingFlip(LEFT, true, false);
		setFacingFlip(RIGHT, false, false);

		// Get graphic
		loadGraphic(AssetPaths.Torch__png, true, 5, 10);

		// Make animation
		animation.add("X", [0, 1, 2], 6, true);
		animation.play("X");

		// Set facing
		if (direction == 0)
		{
			facing = LEFT;
			x = x + 11;
		}
		else
		{
			facing = RIGHT;
		}
	}
}
