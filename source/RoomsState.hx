package;

import flixel.sound.FlxSound;
import flixel.tweens.FlxTween;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.ui.FlxUI;
import flixel.addons.ui.FlxUIInputText;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import haxe.ds.HashMap;
import io.colyseus.Client;

class RoomsState extends FlxState
{
	var back:FlxText;
	var texts:FlxSpriteGroup = new FlxSpriteGroup(0, 0);
	var client = new Client("ws://10.10.54.185:2567");
	var namemap:Map<FlxText, String> = [];

	override public function create()
	{
		if (FlxG.sound.music != null)
			FlxG.sound.music.stop();
		FlxG.sound.music = new FlxSound();
		FlxG.sound.music.loadEmbedded(AssetPaths.guitar__wav, true);
		FlxG.sound.music.fadeIn();
		FlxG.camera.fade(FlxColor.BLACK, 0.5, true);
		
		back = new FlxText(0, 0, 0, "Back", 16);
		back.screenCenter();
		back.y -= 32;
		add(back);

		client.getAvailableRooms("my_room", function(err, rooms)
		{
			if (err != null)
			{
				trace(err);
				return;
			}

			for (room in rooms)
			{
				trace(room.roomId);
				trace(room.clients);
				trace(room.maxClients);
				trace(room.metadata);
				var text:FlxText = new FlxText(0, 0, 0, room.metadata.roomNam + " [" + room.clients + "/" + room.maxClients + "]", 16);
				text.screenCenter();
				text.y += 32 * texts.length;
				texts.add(text);
				namemap.set(text, room.roomId);
				add(text);
				FlxG.camera.follow(text);
			}
		});

		super.create();
		FlxG.camera.zoom = 2;
	}

	override public function update(elapsed:Float)
	{
		back.scale.set(0.75, 0.75);
		back.color = FlxColor.WHITE;
		if (FlxG.mouse.overlaps(back))
		{
			back.scale.set(1, 1);
			back.color = FlxColor.YELLOW;
			if (FlxG.mouse.justPressed) {
				FlxG.camera.fade(FlxColor.BLACK, 0.75, false, () -> {
					FlxG.switchState(new MenuState());
				});
			}
		}
		texts.forEachOfType(FlxText, function(i)
		{
			i.scale.set(0.75, 0.75);
			i.color = FlxColor.WHITE;
			if (FlxG.mouse.overlaps(i))
			{
				i.scale.set(1, 1);
				i.color = FlxColor.YELLOW;
				if (FlxG.mouse.justPressed)
				{
					MenuState.toJoin = namemap.get(i);
					MenuState.creationChoice = "join";
					FlxG.switchState(new PlayState());
				}
			}
		});
		texts.y -= FlxG.mouse.wheel;
		back.y -= FlxG.mouse.wheel;
		super.update(elapsed);
	}
}
