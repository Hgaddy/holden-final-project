package characterSprites;

import flixel.FlxSprite;

class SandSprite extends FlxSprite
{
	public function new(X:Float = 0, Y:Float = 0)
	{
		// Call super
		super(X, Y);

		// Load Graphic
		loadGraphic(AssetPaths.BigSand__png, true, 80, 105);

		// Make animation
		animation.add("SandStand", [0, 0, 0, 0, 1, 2], 8, true);
		// Play animation
		animation.play("SandStand");
	}
}
