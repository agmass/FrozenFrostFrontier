package;

import flixel.sound.FlxSound;
import flixel.ui.FlxBar;
import flixel.FlxSprite;
import flixel.util.FlxTimer;
import flixel.tweens.FlxEase;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import flixel.text.FlxText;
import flixel.FlxSubState;
import flixel.FlxCamera;
import flixel.FlxG;

class FishSubState extends FlxSubState {
   
    var cammmmm:FlxCamera = new FlxCamera(0,0,0,0,0);
    var text:FlxText = new FlxText(0,0,0,"3", 64);
    var fish:FlxSprite = new FlxSprite(0,0);
    var mash:Int = -1;
    var timeBar:FlxBar;
    var totalmash:Int = 0;
    var fishMusic:FlxSound = new FlxSound();
    override public function new() {
        super();
    }

    override function create() {
        super.create();
        fishMusic.loadEmbedded(AssetPaths.fishing__mp3);
        fishMusic.play();
        FlxG.cameras.add(cammmmm, false);
        cammmmm.bgColor.alphaFloat = 0.5;
        _parentState.persistentDraw = true;
        _parentState.persistentUpdate = true;
        text.color = FlxColor.GREEN;
        cammmmm.alpha = 0;
        text.camera = cammmmm;
        fish.loadGraphic(AssetPaths.fishing__png, true, 1280, 720);
        fish.animation.add("idle", [0], 1, true);
        fish.animation.add("miss", [1], 1, false);
        fish.animation.add("hit", [2], 1, false);
        add(fish);
        add(text);
        timeBar= new FlxBar(40, 20, FlxBarFillDirection.LEFT_TO_RIGHT, 256, 40);
        timeBar.camera = cammmmm;
        timeBar.screenCenter(X);
        timeBar.createColoredFilledBar(FlxColor.WHITE, true, FlxColor.BLACK);
        timeBar.createColoredEmptyBar(FlxColor.BLACK, true, FlxColor.BLACK);
        timeBar.color = FlxColor.YELLOW;
        timeBar.value = 100;
        add(timeBar);
        fish.camera = cammmmm;
        text.y = text.y+1000;
        FlxTween.tween(text, {y: text.y-1000}, 0.75, {ease: FlxEase.bounceOut});
        FlxTween.tween(cammmmm, {alpha: 1}, 1, {onComplete: function(twn) {
            FlxTween.tween(text, {angle: 360, "scale.x": 1.25, "scale.y": 1.25}, 1, {onComplete: (twn) -> {
                text.color = FlxColor.ORANGE;
                text.text = "2";
                text.angle = 0;
                FlxTween.tween(text, {angle: 360, "scale.x": 1.5, "scale.y": 1.5}, 1, {onComplete: (twn) -> {
                    text.color = FlxColor.RED;
                    text.text = "1";
                    text.angle = 0;
                    FlxTween.tween(text, {angle: 360, "scale.x": 1.75, "scale.y": 1.75}, 1, {onComplete: (twn) -> {
                        text.color = FlxColor.GREEN;
                        text.text = "GO!";
                        new FlxTimer().start(0.75, (tmr) -> {
                            text.size = 48;
                            mash = FlxG.random.int(0,3);
                            FlxTween.tween(timeBar, {value: 0}, 30, {onComplete: (twn) -> {
                                mash = -1;
                                if (totalmash < 40) {
                                    text.size = 32;
                                    text.color = FlxColor.RED;
                                    text.text = "YOU FAILED! " + totalmash + "/40";
                                } else {
                                    text.size = 32;
                                    text.color = FlxColor.GREEN;
                                    PlayState.roome.send("endFish");
                                    text.text = "YOU WON! " + totalmash + "/40";
                                }
                                new FlxTimer().start(1, (tmr) -> {
                                    cammmmm.fade(FlxColor.BLACK, 0.5, false, () -> {
                                        close();
                                    });
                                });
                            }});
                        });
                    }, ease: FlxEase.elasticInOut});
                }, ease: FlxEase.elasticInOut});
            }, ease: FlxEase.elasticInOut});
        }});
    
    }

    override function destroy() {
        cammmmm.destroy();
        fishMusic.fadeOut(0.25);
        super.destroy();
    }

    override function update(elapsed:Float) {
        text.screenCenter();
        if (FlxG.keys.pressed.ESCAPE && cammmmm.alpha == 1) {
            close();
        }
        if (mash != -1) {
        switch (mash) {
            case 0:
                text.text = "PRESS UP!!";
                text.color = FlxColor.GREEN;
            case 1:
                text.text = "PRESS DOWN!!";
                text.color = FlxColor.RED;
            case 2:
                text.text = "PRESS LEFT!!";
                text.color = FlxColor.YELLOW;
            case 3:
                text.text = "PRESS RIGHT!!";
                text.color = FlxColor.BLUE;
        }
        if (FlxG.keys.justPressed.RIGHT) {
            if (mash == 3) {
                totalmash++;
                fish.animation.play("hit");
                cammmmm.flash(FlxColor.GREEN, 0.1);
                mash = FlxG.random.int(0,3);
            } else {
                totalmash--;
                fish.animation.play("miss");
                cammmmm.flash(FlxColor.PURPLE, 0.1);
                mash = FlxG.random.int(0,3);
            }
        }
        if (FlxG.keys.justPressed.LEFT) {
            if (mash == 2) {
                totalmash++;
                fish.animation.play("hit");
                cammmmm.flash(FlxColor.GREEN, 0.1);
                mash = FlxG.random.int(0,3);
            } else {
                totalmash--;
                fish.animation.play("miss");
                cammmmm.flash(FlxColor.PURPLE, 0.1);
                mash = FlxG.random.int(0,3);
            }
        }
        if (FlxG.keys.justPressed.UP) {
            if (mash == 0) {
                totalmash++;
                fish.animation.play("hit");
                cammmmm.flash(FlxColor.GREEN, 0.1);
                mash = FlxG.random.int(0,3);
            } else {
                totalmash--;
                fish.animation.play("miss");
                cammmmm.flash(FlxColor.PURPLE, 0.1);
                mash = FlxG.random.int(0,3);
            }
        }
        if (FlxG.keys.justPressed.DOWN) {
            if (mash == 1) {
                totalmash++;
                fish.animation.play("hit");
                cammmmm.flash(FlxColor.GREEN, 0.1);
                mash = FlxG.random.int(0,3);
            } else {
                totalmash--;
                fish.animation.play("miss");
                cammmmm.flash(FlxColor.PURPLE, 0.1);
                mash = FlxG.random.int(0,3);
            }
        }
        }
        super.update(elapsed);
    }
}