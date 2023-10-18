package;

import flixel.tweens.FlxTween;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.FlxSprite;

class ShopTile extends FlxSprite {
    public var icon:FlxSprite;  
    public var price:FlxText;
    public var item:ShopItem;

    override public function new(x, y, shopSprite:String, price:Int = 0, it) {
        super(x,y);
        icon = new FlxSprite(8,8,shopSprite);
        loadGraphic(AssetPaths.bgtile__png);
        this.price = new FlxText(8,8,0,"$" + price);
        item = it;
    }

    override function update(elapsed:Float) {
        super.update(elapsed);
        icon.scale.set(this.scale.x, this.scale.x);
        icon.updateHitbox();
        price.scale.set(this.scale.x, this.scale.x);
        price.updateHitbox();
        icon.camera = camera;
        price.camera = camera;
        icon.setPosition(x + 8, y + 8);
        price.setPosition(x + 8, y + 8);
    } 
}