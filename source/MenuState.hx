package;

import flixel.addons.ui.FlxUIInputText;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;

class MenuState extends FlxState {
    var createro:FlxSprite = new FlxSprite(421, 146, AssetPaths.createroom__png);
    var joinro:FlxSprite = new FlxSprite(310, 347, AssetPaths.findroomroom__png);
    var name:FlxUIInputText = new FlxUIInputText(421, 58, 452, "Name", 64);
    public static var playerName:String = "";
    public static var toJoin:String = "";
    public static var creationChoice:String = "create";
    override function create() {
        var bg:FlxSprite = new FlxSprite(0,0,AssetPaths.menubg__png);
        add(bg);
        FlxG.camera.fade(FlxColor.BLACK, 0.75, true);
        add(createro);
        add(joinro);
        add(name);
        super.create();
    }
    override function update(elapsed:Float) {
        playerName = name.text;
        if (FlxG.mouse.overlaps(createro)) {
            createro.scale.set(1.1, 1.1);
            if (FlxG.mouse.justPressed) {
                creationChoice = "create";
                FlxG.camera.fade(FlxColor.BLACK, 0.75, false, () -> {
                    FlxG.switchState(new PlayState());
                });
            }
            joinro.scale.set(1, 1);
        } else {
            createro.scale.set(1, 1);
            if (FlxG.mouse.overlaps(joinro)) {
                joinro.scale.set(1.1, 1.1);
                if (FlxG.mouse.justPressed) {
                    creationChoice = "join";
                    FlxG.camera.fade(FlxColor.BLACK, 0.75, false, () -> {
                        FlxG.switchState(new RoomsState());
                    });
                }
            } else {
                joinro.scale.set(1, 1);
            }
        }
        super.update(elapsed);
    }
}