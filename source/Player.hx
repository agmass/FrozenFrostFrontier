package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.effects.particles.FlxEmitter;
import flixel.effects.particles.FlxParticle;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxSpriteGroup;
import flixel.input.gamepad.FlxGamepad;
import flixel.input.gamepad.FlxGamepadInputID;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

class Player extends FlxSprite
{
	public var SPEED:Float = 250;
	public var spawnpoint:FlxPoint = new FlxPoint(0, 0);
	public var SUPERSPEEEED:Float = 0;
	public var additions:FlxSpriteGroup = new FlxSpriteGroup();
	public var additionsbehind:FlxSpriteGroup = new FlxSpriteGroup();
	public var extraemit:FlxTypedGroup<FlxEmitter> = new FlxTypedGroup<FlxEmitter>();
	public var face:Float = 0;
	public static var money:Int = 0;

	var alttimer:FlxTimer = new FlxTimer();
	var maintimer:FlxTimer = new FlxTimer();
	public var desiredFOV:Float = 2;

	public var speedmod:Float = 1;
	public var damage:Float = 2;

	public var lockplayer:Bool = false;

	var superAngle:Int = 0;
	public var bunnySprite:FlxSprite = new FlxSprite(0,0);

	public var lockreasoning:String = "none";
	public var maxHealth = 100;

	var particleEmitDelay:Float = 100;
	var canRun:Bool = true;

	public var canShoot:Bool = true;

	public var particles:FlxEmitter;

	var ablitiy1cooldown:Int = 4;

	public var gunCooldown = 0.15;
	public var stamina:Float = 100;
	public var maxAmmo = 80;
	public var staminaBar:FlxBar = new FlxBar(20, 20, FlxBarFillDirection.LEFT_TO_RIGHT, 128, 20);
	public var pickUpBar:FlxBar= new FlxBar(20, 20, FlxBarFillDirection.LEFT_TO_RIGHT, 64, 10);
	public var ammo = 80;
	public var isreloading = false;
	public var locktimeLeft:Int = 0;
	public var healthtext:FlxText = new FlxText(0, 0, 0, "100/100", 64);
	public var ammotext:FlxText = new FlxText(0, 0, 0, "100/100", 16);
	var truerot:Float = 0;
	var currot:Float = 0;
	var barsinit = false;

	// public var abilityhints:FlxTypedGroup<>;

	public function new(x:Float = 0, y:Float = 0)
	{
		money = 0;
		bunnySprite.loadGraphic(AssetPaths.bunny__png, true, 32, 32);
		bunnySprite.animation.add("idle", [0]);
		bunnySprite.animation.add("walk", [1,2], 5);
		bunnySprite.animation.add("glide", [2], 5);
		bunnySprite.animation.add("dance", [2,3,4,5], 15);
		bunnySprite.visible = false;
		particles = new FlxEmitter(0, 0);
		super(x, y);
		loadGraphic(AssetPaths.character__png, true, 32, 32);
		animation.add("idle", [0]);
		animation.add("walk", [0,1,2,3], 5);
		animation.add("backwalk", [5,4,5,6],5);
		animation.add("dance", [8,9,10,11],4,true);
		animation.add("pick", [12], 5);
		health = maxHealth;
		SPEED = 350;
		drag.x = drag.y = 2400;
		particles.makeParticles(1, 1, FlxColor.WHITE, 1000);
		ammotext.color = FlxColor.GRAY;
		pickUpBar.alpha = 0;
	}

	override public function update(elapsed:Float)
	{
		bunnySprite.x = x;
		bunnySprite.y = y;
		bunnySprite.flipX = !flipX;
		if (!barsinit) {
			barsinit = true;
			pickUpBar.createColoredFilledBar(FlxColor.WHITE, true, FlxColor.BLACK);
			pickUpBar.createColoredEmptyBar(FlxColor.BLACK, true, FlxColor.BLACK);
			pickUpBar.color = FlxColor.GRAY;
			staminaBar.createColoredFilledBar(FlxColor.BLUE, true, FlxColor.BLACK);
			staminaBar.createColoredEmptyBar(FlxColor.BLACK, true, FlxColor.BLACK);
			staminaBar.setRange(0, maxAmmo);
		}
		if (health > maxHealth)
			health = maxHealth;
		pickUpBar.setRange(0, 1000);
		ammotext.alpha = staminaBar.alpha / 2;

		if (PlayState.roome != null) {
			healthtext.text = "$" + money;
		}
		healthtext.scrollFactor.set(0, 0);
		healthtext.x = 20;
		healthtext.y = 20;
		//healthtext.alpha = 0;
		healthtext.color = FlxColor.GREEN;

		//healthBar.visible = false;
		staminaBar.visible = FlxG.state.subState == null;
		healthtext.visible = FlxG.state.subState == null;
		//healthtext.visible = false;
		ammotext.visible = FlxG.state.subState == null;
		additions.visible = FlxG.state.subState == null;

		if (FlxG.state.subState != null)
		{
			velocity.set(0,0);
		}
		if (!lockplayer)
		{
			if (FlxG.keys.pressed.E) {

				trace("Dancing");
				if (animation.name != "dance") {
					PlayState.roome.send("dance", true);
					animation.play("dance", true);
				}
				if (bunnySprite.animation.name != "dance") {
					bunnySprite.animation.play("dance", true);
				}
				desiredFOV = 2.75;
			} else {

				if (animation.name == "dance") {
					PlayState.roome.send("dance", false);
					animation.play("idle", true);
				}
				if (bunnySprite.animation.name == "dance") {
					bunnySprite.animation.play("idle", true);
				}
			if (FlxG.state.subState == null)
			{
				


				var up:Bool = false;
				var down:Bool = false;
				var left:Bool = false;
				var right:Bool = false;

				up = FlxG.keys.anyPressed([UP, W]);
				down = FlxG.keys.anyPressed([DOWN, S]);
				left = FlxG.keys.anyPressed([LEFT, A]);
				right = FlxG.keys.anyPressed([RIGHT, D]);
		
				particleEmitDelay -= 100 * (SUPERSPEEEED / 100);
				var coolColor:FlxColor = FlxColor.BLUE;
				if (up && down)
					up = down = false;
				if (left && right)
					left = right = false;
				if (up || down || left || right)
				{
					desiredFOV = 1.7;
					if (FlxG.keys.pressed.SHIFT) {
						desiredFOV = 1.5;
					}
					velocity.x = SPEED;
					velocity.y = SPEED;
					var newAngle:Float = 0;
					if (up)
					{
						newAngle = -90;
						superAngle = -90;
						if (left)
						{
							newAngle -= 45;
						}
						else if (right)
						{
							newAngle += 45;
						}
					}
					else if (down)
					{
						superAngle = 90;
						newAngle = 90;
						if (left)
						{
							newAngle += 45;
						}
						else if (right)
						{
							newAngle -= 45;
						}
					}
					else if (left)
					{
						superAngle = 180;
						newAngle = 180;
					}
					else if (right)
					{
						superAngle = 0;
						newAngle = 0;
					}
		
					if (!up) {
						if (animation.name != "walk")
							animation.play("walk", true);
					} else {
						if (animation.name != "backwalk")
							animation.play("backwalk", true);
					}
					if (left) {
						flipX = true;
					}
					if (right) {
						flipX = false;
					}
					truerot = newAngle;
					if (SUPERSPEEEED > 0) {
						SPEED += SUPERSPEEEED*1.5;
						desiredFOV += SUPERSPEEEED/300;
						if (bunnySprite.animation.name != "glide")
							bunnySprite.animation.play("glide", true);
					} else {
						if (bunnySprite.animation.name != "walk")
							bunnySprite.animation.play("walk", true);
					}
					velocity.setPolarDegrees((SPEED) * speedmod, newAngle);
				} else {
					desiredFOV = 2.25;
					if (animation.name != "idle" && animation.name != "dance")
						animation.play("idle", true);
					if (bunnySprite.animation.name != "idle" && bunnySprite.animation.name != "dance")
						bunnySprite.animation.play("idle", true);
				}
				staminaBar.value = ammo;
				staminaBar.setRange(0, maxAmmo);
				staminaBar.scrollFactor.set(0, 0);
				staminaBar.x = 20;
				staminaBar.y = 40 + 64;

				ammotext.text = ammo + "/" + maxAmmo;
				ammotext.scrollFactor.set(0, 0);
				ammotext.x = 20;
				ammotext.y = 50;

				particles.x = x + 16;
				particles.y = y + 16;
				}
			}
		}
		if (pickUpBar.value != 0 && pickUpBar.alpha == 0) {
			FlxTween.tween(pickUpBar, {alpha: 1}, 0.1);
		}
		pickUpBar.x = x - 16;
		pickUpBar.y = y - 15;
		super.update(elapsed);
	}

}
