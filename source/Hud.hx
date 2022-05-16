package;

import character.CharacterSelector;
import character.CharacterTypes;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxPoint;
import flixel.text.FlxText;

class Hud extends FlxTypedGroup<FlxSprite>
{
	// Incoming variables
	private var numPlayers:Int;
	private var characterChoices:Array<CharacterTypes> = [];

	public var characterHeads:FlxTypedGroup<CharacterSelector>;
	public var crowns:FlxTypedGroup<FlxSprite>;
	public var scores:FlxTypedGroup<FlxText>;

	// Tracking variables
	public var player1Score:Int = 0;
	public var player2Score:Int = 0;
	public var player3Score:Int = 0;
	public var player4Score:Int = 0;

	public function new(numPlayers:Int, characterChoices:Array<CharacterTypes>)
	{
		super();

		// Assign values
		this.numPlayers = numPlayers;
		this.characterChoices = characterChoices;
	}

	public function initCharacterHeads()
	{
		var result = new FlxTypedGroup<CharacterSelector>(4);
		var startingPositions:Array<FlxPoint> = [
			FlxPoint.weak(20, 15),
			FlxPoint.weak(FlxG.width - 80, 15),
			FlxPoint.weak(20, FlxG.height - 65),
			FlxPoint.weak(FlxG.width - 80, FlxG.height - 65)
		];
		for (i in 0...numPlayers)
		{
			result.add(new CharacterSelector(startingPositions[i].x, startingPositions[i].y, characterChoices[i], true));
		}
		characterHeads = result;
	}

	public function initCrowns()
	{
		var result = new FlxTypedGroup<FlxSprite>(4);
		var startingPositions:Array<FlxPoint> = [
			FlxPoint.weak(25, 70),
			FlxPoint.weak(FlxG.width - 75, 70),
			FlxPoint.weak(25, FlxG.height - 86),
			FlxPoint.weak(FlxG.width - 75, FlxG.height - 86)
		];
		for (i in 0...numPlayers)
		{
			result.add(new FlxSprite(startingPositions[i].x, startingPositions[i].y, AssetPaths.Crown__png));
		}
		crowns = result;
	}

	public function initScores()
	{
		var result = new FlxTypedGroup<FlxText>(4);
		var startingPositions:Array<FlxPoint> = [
			FlxPoint.weak(62, 66),
			FlxPoint.weak(FlxG.width - 38, 66),
			FlxPoint.weak(62, FlxG.height - 90),
			FlxPoint.weak(FlxG.width - 38, FlxG.height - 90)
		];
		for (i in 0...numPlayers)
		{
			result.add(new FlxText(startingPositions[i].x, startingPositions[i].y, 0, "0", 15));
		}
		scores = result;
	}

	public function addScore(playerNumber:Int)
	{
		switch (playerNumber)
		{
			case 0:
				player1Score++;
			case 1:
				player2Score++;
			case 2:
				player3Score++;
			case 3:
				player4Score++;
		}
		updateScore(playerNumber);
	}

	private function updateScore(playerNumber:Int)
	{
		switch (playerNumber)
		{
			case 0:
				scores.members[0].text = "" + player1Score;
			case 1:
				scores.members[1].text = "" + player2Score;
			case 2:
				scores.members[2].text = "" + player3Score;
			case 3:
				scores.members[3].text = "" + player4Score;
		}
	}
}
