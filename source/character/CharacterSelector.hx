package character;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;

class CharacterSelector extends FlxSprite
{
	public var type(default, set):CharacterTypes;
	public var isHead:Bool = false;

	public function new(X:Float = 0, Y:Float = 0, Type:CharacterTypes = CharacterTypes.Moss, isHead:Bool = false)
	{
		// Call super
		super(X, Y);

		this.isHead = isHead;
		type = Type; // "set" behavior defined above means this will end up setting graphic too
	}

	private function selectGraphic()
	{
		if (isHead)
		{
			var newGraphic:FlxGraphicAsset;
			switch (type)
			{
				case Navy:
					newGraphic = AssetPaths.NavyHead__png;
				case Moss:
					newGraphic = AssetPaths.MossHead__png;
				case Rose:
					newGraphic = AssetPaths.RoseHead__png;
				case Sand:
					newGraphic = AssetPaths.SandHead__png;
			}
			loadGraphic(newGraphic, true, 60, 50);
		}
		else
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
	}

	private function set_type(newType:CharacterTypes):CharacterTypes
	{
		type = newType;
		selectGraphic();
		return type;
	}
}
