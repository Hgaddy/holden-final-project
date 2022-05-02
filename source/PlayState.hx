package;

import bullet.Bullet;
import character.Don;
import character.Liz;
import character.Wes;
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

	// Controller variables
	var gamepad1:FlxGamepad;
	var gamepad2:FlxGamepad;

	// Player variables
	var player1:Player;
	var player2:Player;

	// Bullet variables
	public var bulletsPlayer1:FlxTypedGroup<Bullet>;
	public var bulletsPlayer2:FlxTypedGroup<Bullet>;

	override public function create()
	{
		super.create();

		project = new LdtkProject();

		levelsCollision = new Map<Int, FlxTilemap>();

		for (level in project.levels)
		{
			loadBackground(level);
			loadCollision(project, level.uid);
			loadVisuals(project, level.uid);
			// loadEntities(project, level.uid);
		}

		currentLevel = project.levels[0];
		currentLevelCollision = levelsCollision.get(currentLevel.uid);

		// Get gamepads
		gamepad1 = FlxG.gamepads.getByID(0);
		gamepad2 = FlxG.gamepads.getByID(1);

		// Create player
		player1 = new Wes(20, 20, gamepad1);
		player2 = new Don(FlxG.width - 20, FlxG.height - 20, gamepad2);

		// Add bullets
		add(bulletsPlayer1 = new FlxTypedGroup<Bullet>(20));
		add(bulletsPlayer2 = new FlxTypedGroup<Bullet>(20));

		// Add player
		add(player1);
		add(player2);
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

		// Render layer "IntGrid"
		level.l_Walls_IntGrid.render(container);
	}

	private function loadEntities(project:LdtkProject, levelId:Int)
	{
		// // Retrieve the level currently loaded
		// var level = project.getLevel(levelId);

		// // Iterate through all 'Player' entities in the layer 'Entities'
		// players = new FlxTypedGroup<Player>(level.l_Entities.all_Player.length);
		// for (playerEntity in level.l_Entities.all_Player)
		// {
		// 	players.add(instantiatePlayer(playerEntity));
		// }
		// add(players);

		// // Victory message
		// victoryMessage = instantiateVictoryMessage(level.l_Entities.all_Victory_Message[0]);

		// add (victoryMessage);
	}

	// private function instantiatePlayer(playerEntity:LdtkProject.Entity_Player):Player
	// {
	// 	return new Player(playerEntity.pixelX, playerEntity.pixelY, // Colors need alpha channel info added, same idea as background loading.
	// 		0xFF000000 + playerEntity.f_Color_int, playerEntity.f_Player_Id);
	// }
	// private function instantiateVictoryMessage(victoryMessageEntity:LdtkProject.Entity_Victory_Message):FlxText
	// {
	// 	var victoryMessage = new FlxText(victoryMessageEntity.pixelX, victoryMessageEntity.pixelY, victoryMessageEntity.width, victoryMessageEntity.f_Message,
	// 		victoryMessageEntity.height);
	// 	victoryMessage.visible = false;
	// 	return victoryMessage;
	// }

	override public function update(elapsed:Float)
	{
		// Call super
		super.update(elapsed);

		// Bullet collision
		FlxG.overlap(player1, bulletsPlayer1, Player.overlapsWithBullet);
		FlxG.overlap(player2, bulletsPlayer1, Player.overlapsWithBullet);
		FlxG.overlap(currentLevelCollision, bulletsPlayer1, Bullet.bounce);

		// Wall collision
		FlxG.collide(currentLevelCollision, player1);
	}

	public function spawnBullet(X:Float, Y:Float, angle:Float)
	{
		var recycled:Bullet = bulletsPlayer1.add(bulletsPlayer1.recycle(Bullet));
		recycled.fire(X, Y, angle);
	}
}
