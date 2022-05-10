package characterSprites;

import flixel.FlxSprite;

class NavySprite extends FlxSprite
{
	public function new(X:Float = 0, Y:Float = 0)
	{
		// Call super
		super(X, Y);

		// Load Graphic
		loadGraphic(AssetPaths.BigNavy__png, true, 80, 105);

		// Make animation
		animation.add("NavyStand", [0, 0, 0, 0, 1, 2], 8, true);
		// Play animation
		animation.play("NavyStand");
	}
}
