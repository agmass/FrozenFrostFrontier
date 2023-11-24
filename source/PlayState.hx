package;

import flixel.sound.FlxSound;
import FIshSubState;
import flixel.math.FlxPoint;
import flixel.tweens.FlxEase;
import flixel.text.FlxText;
import flixel.util.FlxTimer;
import io.colyseus.error.MatchMakeError;
import io.colyseus.Room;
import io.colyseus.Client;
import flixel.util.FlxColor;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxSpriteGroup;
import flixel.tweens.FlxTween;
import flixel.tile.FlxTilemap;
import flixel.addons.editors.ogmo.FlxOgmo3Loader;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.FlxCamera;
import flixel.FlxState;

class PlayState extends FlxState
{
	public var plr:Player = new Player(781,502);
	public static var items:Array<Int> = [];
	var uiCam:FlxCamera = new FlxCamera(0,0,0,0);
	var totalSaved:Array<Float> = [];
	var gameCam:FlxCamera = new FlxCamera(0,0,0,0);
	var currentFOV:Float = 0;	
	var locktitle:Bool = false;
	var isrdy:Bool = false;
	var map:FlxOgmo3Loader;
	var walls:FlxTilemap;
	var detail:FlxTilemap;
	var title:FlxText = new FlxText(0,128,0,"NOT READY (0/0)",48);
	var isFading:Bool = false;
	var tents:FlxTypedGroup<Tent> = new FlxTypedGroup();
	var eventors:FlxTypedGroup<EventZone> = new FlxTypedGroup();
	var allice:FlxSpriteGroup = new FlxSpriteGroup();
	var trash:FlxSpriteGroup = new FlxSpriteGroup();
	var Oplayers:FlxSpriteGroup = new FlxSpriteGroup();
	var penguins:FlxSpriteGroup = new FlxSpriteGroup();
	var seals:FlxSpriteGroup = new FlxSpriteGroup();
	var pbears:FlxSpriteGroup = new FlxSpriteGroup();
	var machines:FlxSpriteGroup = new FlxSpriteGroup();
	var savedpenguins:FlxSpriteGroup = new FlxSpriteGroup();
	var bunnies:FlxSpriteGroup = new FlxSpriteGroup();
	var apples:FlxSpriteGroup = new FlxSpriteGroup();
	var itemList:FlxSpriteGroup = new FlxSpriteGroup();
	var look:Array<Array<Int>> = [];
	var bunnyMusic:FlxSound;
	var bmhint:FlxSprite = new FlxSprite(0,0,AssetPaths.bmhint__png);

	public static var roome:Room<MyRoomState>;
	var machinebars:FlxSprite = new FlxSprite(0,0,AssetPaths.squarifier__png);
	var machinetext:FlxText = new FlxText(0,0,0,"COLLECTED: 0", 64);
	public static var client = new Client("ws://10.10.54.185:2567");
	override public function create()
	{
		bmhint.visible = false;
		FlxG.autoPause = false;
		FlxG.cameras.reset(gameCam);
		FlxG.cameras.add(uiCam, false);
		uiCam.bgColor.alpha = 0;
		title.camera = uiCam;
		title.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 3, 1);
		add(title);
		map = new FlxOgmo3Loader(AssetPaths.frost__ogmo, AssetPaths.map__json);
		walls = map.loadTilemap(AssetPaths.tiles__png, "walls");
		walls.follow();
		walls.camera = gameCam;
		walls.setTileProperties(1, NONE);
		walls.setTileProperties(2, ANY);
		walls.setTileProperties(4, NONE);
		walls.setTileProperties(3, NONE);
		//walls.setTileProperties(8, NONE);
		walls.setTileProperties(9, NONE);
		walls.setTileProperties(8, NONE);
		walls.setTileProperties(10, NONE);
		add(walls);
		detail = map.loadTilemap(AssetPaths.yipee__png, "detail");
		detail.follow();
		detail.camera = gameCam;
		detail.setTileProperties(1, NONE);
		detail.setTileProperties(2, NONE);
		detail.setTileProperties(3, NONE);
		detail.setTileProperties(4, NONE);
		detail.setTileProperties(5, NONE);
		detail.setTileProperties(6, NONE);
		detail.setTileProperties(7, NONE);
		detail.setTileProperties(8, NONE);
		detail.setTileProperties(9, NONE);
		detail.setTileProperties(10, NONE);
		detail.setTileProperties(11, NONE);
		//detail.setTileProperties(12, NONE);
		add(detail);
		add(eventors);
		add(penguins);
		penguins.camera = gameCam;
		add(savedpenguins);
		savedpenguins.camera = gameCam;
		map.loadEntities(placeEntities, "entities");
		add(plr);
		new FlxTimer().start(0.16666666667, (tmr) -> {
			plr.SUPERSPEEEED -= 40;
		}, 0);
		add(plr.bunnySprite);
		add(plr.healthtext);
		//add(plr.staminaBar);
		add(plr.particles);
		add(plr.pickUpBar);
		add(plr.additions);
		add(Oplayers);
		add(tents);
		add(trash);
		add(seals);
		add(bunnies);
		add(pbears);
		add(apples);
		itemList.camera = uiCam;
		add(itemList);
		machinebars.camera = uiCam;
		machinetext.camera = uiCam;
		plr.camera = gameCam;
		plr.additions.camera = gameCam;
		plr.particles.camera = gameCam;
		plr.staminaBar.camera = uiCam;
		plr.healthtext.camera = uiCam;
		gameCam.zoom = 2.25;
		FlxG.camera.follow(plr, FlxCameraFollowStyle.LOCKON, 0.85);
		for (i in 0...walls.totalTiles) {
			if (walls.getTileByIndex(i) == 1) {
				detail.setTileByIndex(i, FlxG.random.int(1,4));
			}
			if (walls.getTileByIndex(i) == 2) {
				detail.setTileByIndex(i, FlxG.random.int(5,7));
			}
			if (walls.getTileByIndex(i) == 10) {
				detail.setTileByIndex(i, FlxG.random.int(8,11));
			}
		}
		if (MenuState.creationChoice == "create") {
			client.create("my_room", [], MyRoomState, (e, mme) -> {
				epic(e, mme);
			});
		}
		if (MenuState.creationChoice == "join") {
			client.joinById(MenuState.toJoin, [], MyRoomState, (e, mme) -> {
				epic(e, mme);
			});
		}
		add(machinebars);
		machinebars.visible = false;
		add(machinetext);
		machinetext.visible = false;
		super.create();

	}
	function epic(err:MatchMakeError, room:Room<MyRoomState>) {
		trace(room);
		roome = room;
		var cstate:Int = room.state.state;
		if (err != null)
		{
			trace("JOIN ERROR: " + err);
			return;
		}
		room.send("name", MenuState.playerName);
		trace("Joined with success!");
		room.state.listen("state", function(c,p) {
			cstate = c;
		});
		new FlxTimer().start(0.000166666666667, function(tmr) {
			room.send("pos", {x: plr.x, y: plr.y});
			if (cstate == 0 || cstate == 4) {
			if (isrdy) {
				title.color = FlxColor.GREEN;
				title.text = "READY (" + room.state.readyCount+ "/" + room.state.players.length + ")";
			} else {
				title.color = FlxColor.RED;
				title.text = "NOT READY (" + room.state.readyCount + "/" + room.state.players.length + ")";
			}
			if (room.state.readyCount >= room.state.players.length) {
				title.text = "STARTING IN " + room.state.timer;
				title.color = FlxColor.WHITE;
			}
			} else {
				if (!locktitle) {
					if (title.alpha == 1) {
						FlxTween.tween(title, {alpha: 0}, 0.5, {ease: FlxEase.cubeInOut});
					} 
				}
			} 
		}, 0);
		room.onMessage("teleport", function(y)
			{
				plr.setPosition(y.x, y.y);
			});
			room.onMessage("teleporttoship", function(y)
				{
					plr.setPosition(plr.x + 2017, plr.y + 579);
					var whitetempl:FlxSprite = new FlxSprite(0,0);
					whitetempl.camera = uiCam;
					whitetempl.scrollFactor.set(0,0);
					whitetempl.makeGraphic(2000, FlxG.height);
					add(whitetempl);
					var tutorial:FlxText = new FlxText(0,0,0,"Welcome to antarctica!",32);
					tutorial.camera = uiCam;
					plr.lockreasoning = "intro";
					tutorial.scrollFactor.set(0,0);
					tutorial.color = FlxColor.BLACK;
					add(tutorial);
					tutorial.alpha = 0;
					tutorial.screenCenter();
					var tutorialMusic:FlxSound = new FlxSound();
					tutorialMusic.loadEmbedded(AssetPaths.tutorial__mp3);
					tutorialMusic.play();
					FlxTween.tween(tutorial, {alpha: 1}, 1, {onComplete: function(twn) {
						var dialouge:Array<String> = [
							"This place is in need of help.",
							"You are on a time limit until the next day!",
							"Do your best to clean up and save the\n wildlife to get a better score!",
							"Use WASD to move, and SPACE to Interact.",
							"You can interact with trash, animals or others.",
							"Try getting a shovel in the orange \ntent first, get money by picking trash!",
							"Good luck!",
							"END"
						];
						var e = 0;
						var islekill:Bool = false;
						new FlxTimer().start(0.166666667, (tmr) -> {
							if (islekill)
								tmr.cancel();
							if (FlxG.keys.pressed.ESCAPE) {
								islekill = true;
								tutorialMusic.fadeOut(0.25);
								tutorial.destroy();
								whitetempl.destroy();
								FlxG.camera.flash(FlxColor.WHITE, 0.25);
							}
						}, 0);
						for (i in dialouge) {
							e++;
							new FlxTimer().start(5 * e, function(tmr) {
								if (!islekill) {
								uiCam.flash(FlxColor.WHITE, 0.75);
								tutorial.text = i;
								tutorial.screenCenter();
								if (i == "END") {
									uiCam.flash(FlxColor.WHITE, 0.75);
								tutorial.destroy();
								FlxTween.tween(whitetempl, {alpha: 0}, 0.75,{ onComplete: function(twn) {
									whitetempl.destroy();
									plr.lockplayer = false;
								}});
								}
								}
							});
						}
					}});
					gameCam.fade(FlxColor.WHITE, 4, true);
				});
		room.state.saved.onAdd(function(s, d) {
			totalSaved.push(s);
		});
		room.onMessage("focus", function(x) {
			locktitle = true;
			title.text = x.tx;
			title.alpha = 1;
			title.color = FlxColor.BLUE;
			gameCam.follow(null);
			gameCam.scroll.x = x.x;
			gameCam.scroll.y = x.y;
			new FlxTimer().start(x.t, (tmr) -> {
				locktitle = false;
				gameCam.follow(plr, FlxCameraFollowStyle.LOCKON, 0.85);
			});
		});
		room.state.trash.onAdd(function(item:Trash, key:String) {
			var trash2:FlxSprite = new FlxSprite(item.x, item.y);
			trash2.loadGraphic(AssetPaths.trash__png, true, 32,32);
			trash2.animation.add("D", [FlxG.random.int(0,1)]);
			trash2.animation.play("D");
			trash2.health = Std.parseFloat(key);
			trash.add(trash2);
			item.onRemove(() -> {
				trash.remove(trash2);
				trash2.destroy();
			});
		});
		room.state.players.onAdd(function(item:OtherPlayer, key:String) {
			if (key != room.sessionId) {
				var nP:FlxSprite = new FlxSprite(item.x, item.y);
				nP.loadGraphic(AssetPaths.character__png, true, 32, 32);
				nP.animation.add("idle", [0], 5);
				nP.animation.add("walk", [0,1,2,3], 4, false);
				nP.animation.add("backwalk", [5,4,5,6],4, false);
				nP.animation.add("dance", [8,9,10,11],4,true);
				Oplayers.add(nP);
				var playerNm:FlxText = new FlxText(0, 0, 0, "", 16);
				playerNm.text = item.name;
				playerNm.alpha = 0.5;
				Oplayers.add(playerNm);
				var cooltimer:FlxTimer = new FlxTimer().start(0.5, function(tmr) {
					if (nP == null) {
						tmr.cancel();
						return;
					} else {
						if (nP.animation.finished&& nP.animation.name != "dance") {
							nP.animation.play("idle", true);
						}
					}
				}, 0);
				item.onRemove(() -> {
					FlxTween.cancelTweensOf(nP);
					cooltimer.cancel();
					nP.destroy();
					playerNm.destroy();
				});
				item.listen("name", function(cur, prev)
					{
						playerNm.text = cur;
					});
				item.listen("x", function(c,p) {
					FlxTween.tween(nP, {x: c}, 0.05);
					FlxTween.tween(playerNm, {x: c + (nP.width - playerNm.width) / 2}, 0.025);
					if (nP.animation.name != "walk" && nP.animation.name != "backwalk"&& nP.animation.name != "dance")
						nP.animation.play("walk", true);
					if (p > c) {
						nP.flipX = true;
					} else {
						nP.flipX = false;
					}
				});
				item.listen("dance", function(c,p) {
					trace(c);
					if (c == false) {
						nP.animation.play("idle", true);
					} else {
						nP.animation.play("dance", true);
					}
				});
				item.listen("y", function(c,p) {
					FlxTween.tween(nP, {y: c}, 0.15);
					FlxTween.tween(playerNm, {y: c - 32}, 0.015);
					if (c < p) {
						if (nP.animation.name != "backwalk" && nP.animation.name != "dance")
							nP.animation.play("backwalk", true);
					} else {
						if (nP.animation.name != "walk"&& nP.animation.name != "dance")
							nP.animation.play("walk", true);
					}
				});
			} else {
				var isdance:Bool = false;
				item.items.onAdd((d, itm) -> {
					PlayState.items.push(d);
					var ass:String = AssetPaths.PENGUIINI__png;
					switch (d) {
						case 1:
							ass = AssetPaths.shovel__png;
						case 2:
							ass = AssetPaths.iceboots__png;
						case 3:
							ass = AssetPaths.fishingrod__png;
						case 4:
							ass = AssetPaths.fesh__png;
					}
					var it = new FlxSprite(0,0,ass);
					it.health = d;
					itemList.add(it);
				});
				item.items.onRemove((d, itm) -> {
					PlayState.items.remove(d);
					var firstWithSameAss:FlxSprite = null;
					for (i in itemList) {
						if (i.health == d) {
							firstWithSameAss = i;
							break;
						}
					}
					itemList.remove(firstWithSameAss);
				});
				item.listen("dance", function(c,p) {
					isdance = c;
				});
				item.listen("money", function(c,p) {
					Player.money = c;
				});
				item.listen("inMachine", function(c,p) {
					if (c) {
						var ogx = plr.x;
						var ogy = plr.y;
						bunnyMusic = new FlxSound();
						bunnyMusic.loadEmbedded(AssetPaths.bunnyhop__mp3);
						bunnyMusic.play();
						new FlxTimer().start(60+35, (tmr) -> {
							plr.x = ogx;
							plr.y = ogy;
							var col = 0;
							apples.forEach((s) -> {if (!s.visible) col++;});
							roome.send("finishBunny", col);
						});
						plr.bunnySprite.visible = true;
						plr.visible = false;
						FlxG.camera.follow(plr.bunnySprite);
						machinebars.visible = true;
						machinetext.visible = true;
						FlxG.drawFramerate = 24;
					} else {
						plr.bunnySprite.visible = false;
						plr.visible = true;
						FlxG.camera.follow(plr);
						machinebars.visible = false;
						machinetext.visible = false;
						FlxG.drawFramerate = 60;
					}
				});
				item.listen("ready", function(c,p) {
					isrdy = c;
				});
			}
		});
	}

	function placeEntities(entity:EntityData)
		{
			if (entity.name == "tent")
			{
				var tent:Tent = new Tent(entity.x, entity.y, Reflect.field(entity.values, "color"),Reflect.field(entity.values, "tentAction"));
				tents.add(tent);
				add(tent.insidehitbox);
			}

			if (entity.name == "icezone")
			{
				var ice:FlxSprite = new FlxSprite(entity.x, entity.y);
				ice.makeGraphic(entity.width, entity.height, FlxColor.TRANSPARENT);
				ice.visible = false;
				allice.add(ice);
			}
			if (entity.name == "penguin")
				{
					if (Reflect.field(entity.values, "saved")) {
						var penguin:FlxSprite = new FlxSprite(entity.x,entity.y,AssetPaths.PENGUIINI__png);
						penguin.camera = gameCam;
						savedpenguins.add(penguin);
						penguin.immovable  = true;
						FlxTween.tween(penguin.scale, {y: 0.85}, 0.5, {type: PINGPONG, ease: FlxEase.cubeInOut});
					} else {
						var penguin:FlxSprite = new FlxSprite(entity.x,entity.y,AssetPaths.PENGUIINI__png);
						penguin.camera = gameCam;
						penguins.add(penguin);
						penguin.immovable  = true;
						FlxTween.tween(penguin.scale, {y: 0.85}, 0.5, {type: PINGPONG, ease: FlxEase.cubeInOut});
					}
				}
				if (entity.name == "seal")
					{
						var penguin:FlxSprite = new FlxSprite(entity.x,entity.y);
						penguin.camera = gameCam;
						penguin.loadGraphic(AssetPaths.seal__png, true, 32, 32);
						penguin.immovable = true; 
						penguin.animation.add("unhappy", [0], 1);
						penguin.animation.add("happy", [1], 1);
						penguin.setSize(32,18);
						penguin.y += 32-18;
						penguin.offset.set(0,14);
						penguin.health = Reflect.field(entity.values, "ref");
						seals.add(penguin);
						//FlxTween.tween(penguin.scale, {y: 0.85}, 0.5, {type: PINGPONG, ease: FlxEase.cubeInOut});
					}			
				if (entity.name == "bunny")
				{
					var penguin:FlxSprite = new FlxSprite(entity.x,entity.y);
					penguin.camera = gameCam;
					penguin.loadGraphic(AssetPaths.bunny__png, true, 32, 32);
					penguin.immovable = true; 
					penguin.animation.add("unhappy", [0], 1);
					bunnies.add(penguin);
					//FlxTween.tween(penguin.scale, {y: 0.85}, 0.5, {type: PINGPONG, ease: FlxEase.cubeInOut});
				}				
				if (entity.name == "machine")
				{
					var penguin:FlxSprite = new FlxSprite(entity.x,entity.y);
					penguin.camera = gameCam;
					penguin.loadGraphic(AssetPaths.machin__png, false, 32, 64);
					penguin.immovable = true; 
					machines.add(penguin);
					add(penguin);
				}		
				if (entity.name == "polarbear")
				{
					var penguin:FlxSprite = new FlxSprite(entity.x,entity.y);
					penguin.camera = gameCam;
					penguin.loadGraphic(AssetPaths.PBEAR__png, true, 64, 32);
					penguin.immovable = true; 
					penguin.health = Reflect.field(entity.values, "ref");
					penguin.animation.add("unhappy", [0], 1);
					penguin.animation.add("happy", [1], 1);
					penguin.animation.play("unhappy");
					pbears.add(penguin);
	
				}
				if (entity.name == "apple")
				{
					var penguin:FlxSprite = new FlxSprite(entity.x,entity.y,AssetPaths.apple__png);
					penguin.camera = gameCam;
					apples.add(penguin);
				}
			if (entity.name == "eventZone")
			{
				var evZone:EventZone = new EventZone(entity.x, entity.y);
				evZone.toSend = Reflect.field(entity.values, "toSend");
				evZone.health = Reflect.field(entity.values, "x");
				evZone.makeGraphic(entity.width, entity.height, FlxColor.TRANSPARENT);
				eventors.add(evZone);
			}
			
		}

	override public function update(elapsed:Float)
	{
		var e = 0;
		if (machinetext.visible) {
			machinetext.screenCenter(X);
			var col = 0;
			apples.forEach((s) -> {if (!s.visible) col++;});
			machinetext.y = 40;
			if (col >= 100) {
				machinetext.color = FlxColor.GREEN;
			} else {
				machinetext.color = FlxColor.RED;
			}
			machinetext.text = "COLLECTED: " + col + "/100";
		}
		for (i in itemList) {
			i.x = 20 + (34 * e);
			i.y = 20 + 68;
			e++;
		}
		seals.forEach((seal) -> {
			if (totalSaved.contains(seal.health)) {
				seal.animation.play("happy");
			} else {
				seal.animation.play("unhappy");
			}
		});
		pbears.forEach((seal) -> {
				if (totalSaved.contains(3.1) && seal.health == 3.1) {
					seal.setPosition(3567, 1191);
					seal.animation.play("happy");
				}  else {
					seal.animation.play("unhappy");
				}
				if (totalSaved.contains(3.2) && seal.health == 3.2) {
					seal.setPosition(3884, 1150);
				}  else {
					seal.animation.play("unhappy");
				}
				if (totalSaved.contains(3.3) && seal.health == 3.3) {
					seal.setPosition(2685, 1020);
				}  else {
					seal.animation.play("unhappy");
				}
		});
		persistentDraw = true;
		persistentUpdate = true;
		if (FlxG.keys.justPressed.P) {
			plr.setPosition(plr.x + 2017, plr.y + 579);
		}
		if (FlxG.keys.justPressed.SPACE) {
			var spaceUsed:Bool = false;
			if (plr.lockreasoning == "bmhint") {
				plr.lockreasoning = "";
				plr.lockplayer = false;
				spaceUsed = true;
				bmhint.visible = false;
				roome.send("machineMode");
			}
			if (!plr.bunnySprite.visible) {
			FlxG.overlap(plr, trash, function(plr2, tras) {
				spaceUsed = true;
				plr.lockreasoning = "trash";
				plr.lockplayer = true;
				plr.animation.play("pick", true);
				plr.desiredFOV = 3.33;
				if (plr.pickUpBar.value == 0) {
				if (items.contains(1)) {
					FlxTween.tween(tras.scale, {x: 0, y: 0}, 0.33333333, {ease: FlxEase.cubeInOut});
					FlxTween.tween(plr.pickUpBar, {value: 1000}, 0.333333, {onComplete: function(twn) {
						roome.send("pickTrash", tras.health);
						plr.pickUpBar.value = 0;
						plr.pickUpBar.alpha = 0;
						plr.lockplayer = false;
						plr.lockreasoning = "";
					}});
				} else {
					FlxTween.tween(plr, {x: tras.x, y: tras.y}, 0.3333);
					plr.velocity.set(0,0);
					FlxTween.tween(tras.scale, {x: 0}, 1, {ease: FlxEase.cubeInOut});
				FlxTween.tween(plr.pickUpBar, {value: 1000}, 1, {onComplete: function(twn) {
					roome.send("pickTrash", tras.health);
					plr.pickUpBar.value = 0;
					plr.pickUpBar.alpha = 0;
					plr.lockplayer = false;
					plr.lockreasoning = "";
				}});
				}
				}
				
			});
			if (!spaceUsed) {
				FlxG.overlap(plr, eventors, function(p, ev) {
					if (ev.toSend == "machineMode") {
						if (!bmhint.visible) {
						bmhint.destroy();
						bmhint = new FlxSprite(0,0,AssetPaths.bmhint__png);
						bmhint.camera = uiCam;
						bmhint.screenCenter();
						plr.lockplayer = true;
						plr.lockreasoning = "bmhint";
						add(bmhint);
						}
					} else {
						roome.send(ev.toSend, ev.health);
					}
					spaceUsed = true;
				});
			}
			if (!spaceUsed && items.contains(3)) {
				var tiletype:Int = 0;
				if (FlxG.keys.pressed.W || FlxG.keys.pressed.UP) {
					tiletype = walls.getTile(Math.ceil(plr.x / 32), Math.ceil(plr.y / 32) - 1);
				} else {
					if (FlxG.keys.pressed.S || FlxG.keys.pressed.DOWN) {
						tiletype = walls.getTile(Math.ceil(plr.x / 32), Math.ceil(plr.y / 32) + 1);
					} else {
						if (!plr.flipX) {
							tiletype = walls.getTile(Math.ceil(plr.x / 32) + 1, Math.ceil(plr.y / 32));
						} else {
							tiletype = walls.getTile(Math.ceil(plr.x / 32) - 1, Math.ceil(plr.y / 32));
						}
					}
				}
				trace(tiletype);
				if (tiletype == 2) {
					 if (subState == null)
						openSubState(new FishSubState());
				}
			}
			} else {
				if (plr.SUPERSPEEEED <= 0)
					plr.SUPERSPEEEED = 300;
			}
		}
		title.screenCenter(X);
		if (FlxG.keys.justPressed.ENTER) {
			roome.send("ready");
		}
		if (currentFOV != plr.desiredFOV) {
			FlxTween.cancelTweensOf(gameCam);
			FlxTween.tween(gameCam, {zoom: plr.desiredFOV}, 0.25);
		}
		super.update(elapsed);
		FlxG.collide(plr, walls);
		FlxG.collide(plr, tents);
		FlxG.collide(plr, seals);
		FlxG.collide(plr, bunnies);
		FlxG.collide(plr, machines);
		FlxG.collide(plr, pbears);
		if (plr.bunnySprite.visible) {
		FlxG.overlap(plr, apples, function(p, a) {
			a.visible = false;
		});
		}
		apples.visible = plr.bunnySprite.visible;
		savedpenguins.visible = totalSaved.contains(1);
		penguins.visible = !totalSaved.contains(1);
		if (totalSaved.contains(1)) {
			FlxG.collide(plr, savedpenguins);
		} else {
			FlxG.collide(plr, penguins);
		}
		if (FlxG.overlap(plr, allice)) {
			if (!items.contains(2)) {
			plr.drag.set(2,2);
			trace(plr.velocity, plr.velocity);
			if (plr.velocity.x == 0 && plr.velocity.y == 0) {
				if (plr.lockreasoning == "ice" && plr.lockplayer) {
				plr.lockplayer = false;
				plr.lockreasoning = "";
				}
			} else {
			if (plr.velocity.x != 0 || plr.velocity.y != 0) {
				plr.lockplayer = true;
				plr.lockreasoning = "ice";
			} else {
				plr.lockplayer = false;
				plr.lockreasoning = "";
			}
			}
		 	} else {
				plr.SPEED = 400;
				plr.drag.set(600,600);
			}
		} else {
			if (plr.lockreasoning == "ice" && plr.lockplayer) {
				plr.lockplayer = false;
				plr.lockreasoning = "";
			} 
			if (FlxG.keys.pressed.SHIFT) {
				plr.SPEED = 350;
				plr.drag.set(1200,1200);
			} else {
				plr.SPEED = 250;
				plr.drag.set(2400,2400);
			}
		}
		tents.forEach(tent -> {
			if (FlxG.overlap(plr, tent.insidehitbox) && !isFading) {
				plr.y += 16;
				switch (tent.tentAction) {
					case 1:
						if (subState == null)
							openSubState(new ShopSubState([new ShopItem(AssetPaths.shovel__png, 10, "Shovel\n\n3x Trash pick-up Speed\n$3 per pickup", 1), new ShopItem(AssetPaths.iceboots__png, 100, "Ice Boots\n\nFree Movement on ice", 2)], AssetPaths.shopkeeper1__png, 4));
					case 2:
						if (subState == null)
							openSubState(new LeftSaveSubState(totalSaved));
					case 3:
						if (subState == null)
							openSubState(new ShopSubState([new ShopItem(AssetPaths.fishingrod__png, 69, "Fishing Rod\n\nFish for food! Press SPACE\nNear the sea to fish", 3)], AssetPaths.PENGUIINI__png, 9));
						
					
				}
			}
		});
	}
}
