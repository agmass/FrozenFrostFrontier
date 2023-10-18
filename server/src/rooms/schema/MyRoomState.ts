import { Schema, Context, type, ArraySchema, MapSchema } from "@colyseus/schema";

export class OtherPlayer extends Schema {
  @type("number") x: number;  
  @type("number") y: number;
  @type("boolean") ready: boolean = false;
  @type("boolean") dance: boolean = false;
  @type("boolean") inMachine: boolean = false;
  @type("number") health: number = 0;
  @type([ "number" ]) items = new ArraySchema<number>();
  @type("number") money: number = 0;
  @type("string") name: string = "?Name";
}

export class Trash extends Schema {
  @type("number") x: number;  
  @type("number") y: number;
}


export class MyRoomState extends Schema {
  @type([ "number" ]) saved = new ArraySchema<number>();
  @type({ map: OtherPlayer }) players = new MapSchema<OtherPlayer>();
  @type({ map: Trash }) trash = new MapSchema<Trash>();
  @type("number") state: number = 0;
  @type("number") trashkey: number = 0;
  @type("number") timer: number = -1;
  @type("number") readyCount: number = 0;
}