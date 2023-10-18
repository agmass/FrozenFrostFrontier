package;

import flixel.tweens.FlxEase;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;

class ShopSubState extends FlxSubState {

    var shopItems:Array<ShopItem> = [];
    var shopSprite:String;
    var shopTiles:Array<ShopTile> = [];
    var shopScale:Int = 0;
    var shopCam:FlxCamera = new FlxCamera(0,0,0,0);
    var fakeMM:FlxSprite;
    var textChat:FlxText = new FlxText(0,0,0,"Welcome!",32);

    override public function new(shopItems:Array<ShopItem>, Shopkeeper:String, ShopkeepScale:Int) {
        shopSprite = Shopkeeper;
        shopScale = ShopkeepScale;
        this.shopItems = shopItems;
        FlxG.cameras.add(shopCam, false);
        shopCam.bgColor.alphaFloat = 0.5;
        shopCam.alpha = 0;
        FlxTween.tween(shopCam, {alpha: 1}, 0.25);
        super();
    }

    override function create() {
        super.create();
        _parentState.persistentDraw = true;
        _parentState.persistentUpdate = true;
        var shopUI:FlxSprite = new FlxSprite(0,FlxG.height - 180,AssetPaths.shoplayout__png);
        shopUI.camera = shopCam;
        var shopkeepe:FlxSprite = new FlxSprite(0,0,shopSprite);
        shopkeepe.camera = shopCam;
        shopkeepe.scale.set(shopScale,shopScale);
        shopkeepe.updateHitbox();
        shopkeepe.x = 102 - (shopkeepe.width / 2);
        shopkeepe.y = (FlxG.height - 180) +(120 - shopkeepe.height);
        add(shopkeepe);
        add(shopUI);
        var shopchat:FlxSprite = new FlxSprite(shopkeepe.x + shopkeepe.width - 32, shopkeepe.y - 32,AssetPaths.chatbox__png);
        if (shopSprite == AssetPaths.PENGUIINI__png) {
            shopchat.y = shopkeepe.y - 128;
        }
        add(shopchat);
        shopUI.camera = shopCam;
        shopchat.camera = shopCam;
        textChat.x = shopchat.x + 46;
        textChat.y = shopchat.y + 19;
        add(textChat);
        textChat.color = FlxColor.BLACK;
        textChat.camera = shopCam;
        fakeMM = new FlxSprite(0,0);
        fakeMM.makeGraphic(16,24);
        add(fakeMM);
        fakeMM.visible = false;
        fakeMM.camera = shopCam;
        var e = -1;
        for (i in shopItems) {
            e++;
            var tileBG:ShopTile = new ShopTile(0,0,i.sprite,i.price, i);
            tileBG.scale.set(4,4);
            tileBG.updateHitbox();
            tileBG.x = 206 + (150 * e);
            tileBG.camera = shopCam;
            tileBG.y = shopUI.y + 18;
            add(tileBG);
            shopTiles.push(tileBG);
            add(tileBG.icon);
            add(tileBG.price);
        }
    }

    override function destroy() {
        FlxG.cameras.remove(shopCam, true);
        super.destroy();
    }

    override function update(elapsed:Float) {
        if (shopCam.alpha == 1) {
        if (FlxG.keys.pressed.ESCAPE) {
            close();
        }
        fakeMM.x = FlxG.mouse.getPositionInCameraView(shopCam).x;
        fakeMM.y = FlxG.mouse.getPositionInCameraView(shopCam).y;
        var alreadylapping = false;
        for (i in shopTiles) {
            if (PlayState.items.contains(i.item.item)) {
                i.alpha = 0.5;
                i.icon.alpha = 0.5;
                i.price.alpha = 0.5;
                i.price.text = "SOLD";
            } else {
                i.price.color = FlxColor.GREEN;
                if (!alreadylapping) {
            if (FlxG.overlap(fakeMM, i)) {
                alreadylapping = true;
                textChat.text = i.item.description;
                if (FlxG.mouse.justPressed) {
                    PlayState.roome.send("buyItem", i.item.item);
                }
            }
                if (FlxG.overlap(fakeMM, i) && i.scale.x == 4) {
                    FlxTween.tween(i.scale, {x: 4.25,y: 4.25}, 0.25,{ease: FlxEase.elasticInOut});
                }
                if (!FlxG.overlap(fakeMM, i) && i.scale.x == 4.25) {
                    FlxTween.tween(i.scale, {x: 4, y: 4}, 0.25 ,{ease: FlxEase.elasticInOut});
                }
            }
            }
        }
        }
        super.update(elapsed);
    }
}