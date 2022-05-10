package characterSprites;

import flixel.FlxSprite;

class MossSprite extends FlxSprite
{
	public function new(X:Float = 0, Y:Float = 0)
	{
		// Call super
		super(X, Y);

		// Load Graphic
		loadGraphic(AssetPaths.BigMoss__png, true, 80, 105);

		// Make animation
		animation.add("MossStand", [0, 0, 0, 0, 1, 2], 8, true);
		// Play animation
		animation.play("MossStand");
	}
}
