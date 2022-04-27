package;

import bullet.Bullet;
import character.Don;
import character.Liz;
import character.Wes;
import flixel.FlxG;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.input.gamepad.FlxGamepad;
import flixel.input.gamepad.FlxGamepadManager;
import player.Player;

class PlayState extends FlxState
{
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

		// Get gamepads
		gamepad1 = FlxG.gamepads.getByID(0);
		gamepad2 = FlxG.gamepads.getByID(1);

		// Create player
		player1 = new Don(FlxG.width / 2 - 200, FlxG.height / 2, gamepad1);
		player2 = new Don(FlxG.width / 2 + 200, FlxG.height / 2, gamepad2);

		// Add bullets
		add(bulletsPlayer1 = new FlxTypedGroup<Bullet>(20));
		add(bulletsPlayer2 = new FlxTypedGroup<Bullet>(20));

		// Add player
		add(player1);
		add(player2);
	}

	override public function update(elapsed:Float)
	{
		// Call super
		super.update(elapsed);

		// Bullet collision
		FlxG.overlap(player1, bulletsPlayer2, Player.overlapsWithBullet);
		FlxG.overlap(player2, bulletsPlayer1, Player.overlapsWithBullet);
	}

	public function spawnBullet(X:Float, Y:Float)
	{
		var recycled:Bullet = bulletsPlayer1.add(bulletsPlayer1.recycle(Bullet));
		recycled.fire(X, Y);
	}
}
