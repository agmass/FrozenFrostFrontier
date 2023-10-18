package;

class ShopItem {
    public var sprite:String;
    public var price:Int;
    public var description:String;
    public var item:Int = 0;

    public function new(sprite, price, desc, it) {
        this.sprite = sprite;
        this.price = price;
        this.description = desc;
        this.item = it;
    }
}