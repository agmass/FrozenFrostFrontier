package;

import flixel.group.FlxSpriteGroup;
import flixel.tweens.FlxEase;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;

class LeftSaveSubState extends FlxSubState {


    var saved:Array<Float> = [];
    var svGroup:FlxSpriteGroup = new FlxSpriteGroup();
    var cammmmm:FlxCamera = new FlxCamera(0,0,0,0,0);
    override public function new(savedd) {
        saved = savedd;
        super();
    }

    override function create() {
        super.create();
        FlxG.cameras.add(cammmmm, false);
        cammmmm.bgColor.alphaFloat = 0.5;
        _parentState.persistentDraw = true;
        _parentState.persistentUpdate = true;
        for (i in 1...3) {
            if (!saved.contains(i)) {
                trace("Does not contain");
                var card:FlxSprite = new FlxSprite(0,0,"assets/images/namecard" + Std.string(i) + ".png");
                card.screenCenter(X);
                card.camera = cammmmm;
                svGroup.add(card);
                card.y = svGroup.height;
            }
        }
        add(svGroup);
        svGroup.camera = cammmmm;
    }

    override function destroy() {
        cammmmm.destroy();
        super.destroy();
    }

    override function update(elapsed:Float) {
        if (cammmmm.scroll.y < 0) {
            FlxTween.tween(cammmmm.scroll, {x: 0}, 0.25);
        }
        if (FlxG.keys.pressed.ESCAPE) {
            close();
        }
        cammmmm.scroll.y -= FlxG.mouse.wheel;
        super.update(elapsed);
    }
}