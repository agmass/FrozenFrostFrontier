// 
// THIS FILE HAS BEEN GENERATED AUTOMATICALLY
// DO NOT CHANGE IT MANUALLY UNLESS YOU KNOW WHAT YOU'RE DOING
// 
// GENERATED USING @colyseus/schema 2.0.15
// 


import io.colyseus.serializer.schema.Schema;
import io.colyseus.serializer.schema.types.*;

class OtherPlayer extends Schema {
	@:type("number")
	public var x: Dynamic = 0;

	@:type("number")
	public var y: Dynamic = 0;

	@:type("boolean")
	public var ready: Bool = false;

	@:type("boolean")
	public var dance: Bool = false;

	@:type("boolean")
	public var inMachine: Bool = false;

	@:type("number")
	public var health: Dynamic = 0;

	@:type("array", "number")
	public var items: ArraySchema<Dynamic> = new ArraySchema<Dynamic>();

	@:type("number")
	public var money: Dynamic = 0;

	@:type("string")
	public var name: String = "";

}
