package;

import bullet.Bullet;
import character.Character;
import flixel.FlxG;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.group.FlxSpriteGroup;
import flixel.input.gamepad.FlxGamepad;
import flixel.input.gamepad.FlxGamepadManager;
import flixel.tile.FlxTilemap;
import flixel.util.FlxColor;
import ldtk.Level;
import player.Player;

class PlayState extends FlxState
{
	// Ldtk project
	private var project:LdtkProject;
	private var levelsCollision:Map<Int, FlxTilemap>;
	private var currentLevel:Level;
	private var currentLevelCollision:FlxTilemap;

	// All lists
	var allPlayers:FlxTypedGroup<Player>;
	var allCharacterChoices:FlxGroup;
	var allBullets:FlxGroup;
	var allGamepads:Array<FlxGamepad> = [];

	// Controller variables
	var gamepad1:FlxGamepad;
	var gamepad2:FlxGamepad;

	override public function create()
	{
		// Call super
		super.create();

		// Initialize lists
		allBullets = new FlxGroup();

		// Get gamepads
		gamepad1 = FlxG.gamepads.getByID(0);
		gamepad2 = FlxG.gamepads.getByID(1);
		allGamepads.push(gamepad1);
		allGamepads.push(gamepad2);

		project = new LdtkProject();

		levelsCollision = new Map<Int, FlxTilemap>();

		for (level in project.levels)
		{
			loadBackground(level);
			loadCollision(project, level.uid);
			loadVisuals(project, level.uid);
			loadEntities(project, level.uid);
		}
		// Get collision for level
		currentLevel = project.levels[0];
		currentLevelCollision = levelsCollision.get(currentLevel.uid);

		// Add bullets
		add(allBullets);
		add(allPlayers);
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
	}

	private function loadEntities(project:LdtkProject, levelId:Int)
	{
		// Retrieve the level currently loaded
		var level = project.getLevel(levelId);

		// Iterate through all 'Player' entities in the layer 'Entities'
		allPlayers = new FlxTypedGroup<Player>(level.l_Entities.all_Player.length);
		for (playerEntity in level.l_Entities.all_Player)
		{
			allPlayers.add(instantiatePlayer(playerEntity));
			break;
		}

		// // Victory message
		// victoryMessage = instantiateVictoryMessage(level.l_Entities.all_Victory_Message[0]);

		// add(victoryMessage);
	}

	private function instantiatePlayer(playerEntity:LdtkProject.Entity_Player):Player
	{
		return new Character(playerEntity.pixelX, playerEntity.pixelY, "Navy", playerEntity.f_Player_Id, givePlayerBullets(), gamepad1);
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

	private function reloadLevel()
	{
		FlxG.resetState();
	}

	override public function update(elapsed:Float)
	{
		// Call super
		super.update(elapsed);

		// Wall collision
		FlxG.collide(currentLevelCollision, allPlayers);
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
