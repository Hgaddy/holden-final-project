package;

import bullet.Bullet;
import character.Character;
import character.CharacterTypes;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.effects.FlxTrail;
import flixel.group.FlxGroup;
import flixel.group.FlxSpriteGroup;
import flixel.input.gamepad.FlxGamepad;
import flixel.input.gamepad.FlxGamepadManager;
import flixel.text.FlxText;
import flixel.tile.FlxTilemap;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import ldtk.Level;
import openfl.display.Tilemap;
import player.Player;

class PlayState extends FlxState
{
	// Ldtk project
	private var project:LdtkProject;
	private var levelsCollision:Map<Int, FlxTilemap>;
	private var currentLevel:Level;
	private var levelID:Int;
	private var currentLevelCollision:FlxTilemap;

	// All lists
	var allPlayers:FlxTypedGroup<Player>;
	var allGuns:FlxTypedGroup<FlxSprite>;
	var allTrails:FlxTypedGroup<FlxTrail>;
	var characterChoices:Array<CharacterTypes> = [];
	var allBullets:FlxGroup;
	var allGamepads:Array<FlxGamepad> = [];

	// Tracking variables
	var numPlayers:Int;
	var startTimer:FlxTimer = new FlxTimer();
	var countdownNumber:Int = 3;
	var countdownMessage:FlxText;

	public function new(allGamepads:Array<FlxGamepad>, characterChoices:Array<CharacterTypes>, numPlayers:Int = 2)
	{
		// Call super
		super();

		// Set up variables
		this.allGamepads = allGamepads;
		this.characterChoices = characterChoices;
		this.numPlayers = numPlayers;
	}

	override public function create()
	{
		// Call super
		super.create();

		// start music
		FlxG.sound.playMusic(AssetPaths.playMusic__wav, 0.4, true);

		// Initialize lists
		allBullets = new FlxGroup();
		allGuns = new FlxTypedGroup();
		allTrails = new FlxTypedGroup();

		project = new LdtkProject();

		levelsCollision = new Map<Int, FlxTilemap>();

		// Get current level
		currentLevel = project.levels[0];
		levelID = currentLevel.uid;
		// Load level
		loadBackground(currentLevel);
		loadCollision(project, currentLevel.uid);
		loadVisuals(project, currentLevel.uid);
		loadEntities(project, currentLevel.uid);
		// Get collision for level
		currentLevelCollision = levelsCollision.get(currentLevel.uid);

		// Add bullets
		add(allTrails);
		add(allBullets);
		add(allPlayers);
		// Give guns
		for (player in allPlayers)
		{
			allGuns.add(player.gun);
			add(player.gun);
		}
		startCountdown();
	}

	///////////////////
	// LEVEL LOADING //
	///////////////////
	private function loadBackground(level:Level)
	{
		bgColor = FlxColor.fromInt(0xFF000000 + level.bgColor_int);
	}

	private function loadCollision(project:LdtkProject, levelId:Int)
	{
		// Retrieve the level currently loaded
		var level = project.getLevel(levelId);

		// Collision list
		var collisionValues = [1];

		// generate array from IntGrid layer, zeroes mean no collision
		var mapData:Array<Int> = [
			for (i in 0...Std.int(level.l_Walls_IntGrid.cWid * level.l_Walls_IntGrid.cHei))
			{
				if (level.l_Walls_IntGrid.intGrid.get(i) != null)
				{
					collisionValues.contains(level.l_Walls_IntGrid.intGrid.get(i)) ? 1 : 0;
				}
				else
				{
					0;
				}
			}
		];

		// Use array of 1s and 0s to create an FlxTilemap for collision
		var collisionMap = new FlxTilemap();
		collisionMap.setPosition(level.worldX, level.worldY);
		collisionMap.loadMapFromArray(mapData, level.l_Walls_IntGrid.cWid, level.l_Walls_IntGrid.cHei, AssetPaths.collision__png, 16, 16);

		// We don't care about making the map drawn or updated
		collisionMap.visible = false;
		collisionMap.active = false;

		// Add the collisionMap to the state
		add(collisionMap);

		// Store a reference keyed by level ID for when we want to use this later
		levelsCollision.set(level.uid, collisionMap);
	}

	private function loadVisuals(project:LdtkProject, levelId:Int)
	{
		// Retrieve the level currently loaded
		var level = project.getLevel(levelId);

		// Create an FlxGroup for all level layers
		var container = new FlxSpriteGroup();

		// Place it using level world coordinates (in pixels)
		container.x = level.worldX;
		container.y = level.worldY;
		add(container);

		// Render layers
		level.l_Walls_IntGrid.render(container);
		level.l_Floor.render(container);
		level.l_Void.render(container);
	}

	private function loadEntities(project:LdtkProject, levelId:Int)
	{
		// Retrieve the level currently loaded
		var level = project.getLevel(levelId);

		// Iterate through all 'Player' entities in the layer 'Entities'
		allPlayers = new FlxTypedGroup<Player>(level.l_Entities.all_Player.length);
		var currentPlayer:Int = 0;
		for (playerEntity in level.l_Entities.all_Player)
		{
			allPlayers.add(instantiatePlayer(playerEntity, currentPlayer));
			break;
		}

		// // Victory message
		// victoryMessage = instantiateVictoryMessage(level.l_Entities.all_Victory_Message[0]);

		// add(victoryMessage);
	}

	private function instantiatePlayer(playerEntity:LdtkProject.Entity_Player, currentPlayer:Int):Player
	{
		var character = new Character(playerEntity.pixelX, playerEntity.pixelY, characterChoices[currentPlayer], playerEntity.f_Player_Id,
			givePlayerBullets(), allGamepads[currentPlayer]);
		character.trail = new FlxTrail(character, 12, 0, 0.5, 0.02);
		allTrails.add(character.trail);
		// Turn trail off
		character.trail.kill();
		return character;
	}

	// private function instantiateVictoryMessage(victoryMessageEntity:LdtkProject.Entity_Victory_Message):FlxText
	// {
	// 	var victoryMessage = new FlxText(victoryMessageEntity.pixelX, victoryMessageEntity.pixelY, victoryMessageEntity.width, victoryMessageEntity.f_Message,
	// 		victoryMessageEntity.height);
	// 	victoryMessage.visible = false;
	// 	return victoryMessage;
	// }

	private function givePlayerBullets():FlxTypedGroup<Bullet>
	{
		var bullets = new FlxTypedGroup<Bullet>(20);
		allBullets.add(bullets);

		return bullets;
	}

	private function startCountdown()
	{
		startTimer.start(1, countdown, 5);
	}

	private function countdown(timer:FlxTimer)
	{
		// Get new message
		switch (countdownNumber)
		{
			case 3:
				countdownMessage = new FlxText(FlxG.width / 2, FlxG.height / 2, 30, "3", 50);
			case 2:
				// Kill previous message
				countdownMessage.kill();
				countdownMessage = new FlxText(FlxG.width / 2, FlxG.height / 2, 30, "2", 50);
			case 1:
				// Kill previous message
				countdownMessage.kill();
				countdownMessage = new FlxText(FlxG.width / 2, FlxG.height / 2, 30, "1", 50);
			case 0:
				// Kill previous message
				countdownMessage.kill();
				countdownMessage = new FlxText(FlxG.width / 2, FlxG.height / 2, 200, "START", 50);
				for (player in allPlayers)
				{
					player.canPlay = true;
				}
			case -1:
				// Kill previous message
				countdownMessage.kill();
				countdownNumber = 3;
				return;
		}
		// Decrement countdownNumber
		countdownNumber--;
		// Center text
		countdownMessage.screenCenter(XY);
		// Add text
		add(countdownMessage);
	}

	private function reloadLevel()
	{
		// Get current level
		var level = project.getLevel(levelID);
		// Tracking variable
		var currentPlayer:Int = 0;
		for (playerEntity in level.l_Entities.all_Player)
		{
			allPlayers.members[currentPlayer].reset(playerEntity.pixelX, playerEntity.pixelY);
			allPlayers.members[currentPlayer].gun.reset(playerEntity.pixelX, playerEntity.pixelY);
			allPlayers.members[currentPlayer].canPlay = false;
			currentPlayer++;
			// Check if reached numPlayers
			if (currentPlayer == numPlayers)
			{
				break;
			}
		}
		// Restart countdown
		startCountdown();
	}

	override public function update(elapsed:Float)
	{
		// Call super
		super.update(elapsed);

		// Wall collision
		FlxG.collide(currentLevelCollision, allPlayers);
		// FlxG.collide(currentLevelCollision, allGuns, (tilemap:Dynamic, gun:Dynamic) -> trace(gun));
		FlxG.collide(currentLevelCollision, allBullets, Bullet.bounce);

		// Player and bullet collision
		FlxG.overlap(allPlayers, allBullets, Player.overlapsWithBullet);

		if (FlxG.gamepads.anyJustPressed(BACK))
		{
			FlxG.fullscreen = !FlxG.fullscreen;
		}
		if (FlxG.gamepads.anyJustPressed(START))
		{
			reloadLevel();
		}
	}
}
