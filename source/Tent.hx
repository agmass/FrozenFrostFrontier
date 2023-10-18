package;

import flixel.util.FlxColor;
import flixel.FlxSprite;

class Tent extends FlxSprite {
    
    public var insidehitbox:FlxSprite;
    public var tentAction:Int;
    override public function new(x,y,colorr, ac) {
        super(x,y);
        tentAction = ac;
        insidehitbox = new FlxSprite(x,y);
        insidehitbox.makeGraphic(26, 43, FlxColor.TRANSPARENT);
        insidehitbox.visible = false;
        loadGraphic(AssetPaths.tent__png);
        color = FlxColor.fromString(colorr);
        setSize(114, 40);
        offset.set(0, 72);
        immovable = true;
    }

    override function update(elapsed:Float) {
        super.update(elapsed);
        insidehitbox.x = x + 40;
    }
}