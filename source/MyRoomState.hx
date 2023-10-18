// 
// THIS FILE HAS BEEN GENERATED AUTOMATICALLY
// DO NOT CHANGE IT MANUALLY UNLESS YOU KNOW WHAT YOU'RE DOING
// 
// GENERATED USING @colyseus/schema 2.0.15
// 


import io.colyseus.serializer.schema.Schema;
import io.colyseus.serializer.schema.types.*;

class MyRoomState extends Schema {
	@:type("array", "number")
	public var saved: ArraySchema<Dynamic> = new ArraySchema<Dynamic>();

	@:type("map", OtherPlayer)
	public var players: MapSchema<OtherPlayer> = new MapSchema<OtherPlayer>();

	@:type("map", Trash)
	public var trash: MapSchema<Trash> = new MapSchema<Trash>();

	@:type("number")
	public var state: Dynamic = 0;

	@:type("number")
	public var trashkey: Dynamic = 0;

	@:type("number")
	public var timer: Dynamic = 0;

	@:type("number")
	public var readyCount: Dynamic = 0;

}
