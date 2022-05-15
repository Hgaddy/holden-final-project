package character;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;

class CharacterSelector extends FlxSprite
{
	public var type(default, set):CharacterTypes;

	public function new(X:Float = 0, Y:Float = 0, Type:CharacterTypes = CharacterTypes.Moss)
	{
		// Call super
		super(X, Y);

		type = Type; // "set" behavior defined above means this will end up setting graphic too
	}

	private function selectGraphic()
	{
		var newGraphic:FlxGraphicAsset;
		switch (type)
		{
			case Navy:
				newGraphic = AssetPaths.BigNavy__png;
			case Moss:
				newGraphic = AssetPaths.BigMoss__png;
			case Rose:
				newGraphic = AssetPaths.BigRose__png;
			case Sand:
				newGraphic = AssetPaths.BigSand__png;
		}
		loadGraphic(newGraphic, true, 80, 105);

		// Make animation
		animation.add("stand", [0, 0, 0, 0, 1, 2], 7.77, true);
		// Play animation
		animation.play("stand");
	}

	private function set_type(newType:CharacterTypes):CharacterTypes
	{
		type = newType;
		selectGraphic();
		return type;
	}
}
