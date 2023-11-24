import { Room, Client } from "@colyseus/core";
import { MyRoomState, OtherPlayer, Trash } from "./schema/MyRoomState";

export class MyRoom extends Room<MyRoomState> {
  maxClients = 4;

  onCreate (options: any) {
    this.setState(new MyRoomState());
    this.setMetadata({ roomNam: "Unclaimed Room" });

    this.onMessage("pos", (client, x) => {
      const player = this.state.players.get(client.sessionId);
      player.x = x.x;
      player.y = x.y;
    }); 
    this.onMessage("ready", (client, x) => {
      const player = this.state.players.get(client.sessionId);
      player.ready = !player.ready;
    }); 

    this.onMessage("finishBunny", (client, x) => {
      const player = this.state.players.get(client.sessionId);
      player.inMachine = false;
      console.log(x);
      if (x >= 100) {
        setTimeout(() => {
          this.broadcast("focus", {x: player.x - (1280 /2), y: player.y - (720 / 2), t: 3, tx: "The Bunnies have been fed!"});
          this.state.saved.push(4);
        }, 10)
      }
    }); 

    this.onMessage("dance", (client, x) => {
      const player = this.state.players.get(client.sessionId);
      player.dance = x;
    }); 
    this.onMessage("machineMode", (client, x) => {
      const player = this.state.players.get(client.sessionId);
      player.inMachine = true;
    }); 

    this.onMessage("name", (client, y) => {
      const player = this.state.players.get(client.sessionId);
      player.name = y; 
      if (player.name == "Name") {
        player.name = "Guest" + Math.round(Math.random() * 999); 
      }
      if (this.metadata.roomNam == "Unclaimed Room") {
        this.metadata.roomNam = player.name + "'s Room";
      }
      console.log(client.sessionId, "joined! (known as " + this.state.players.get(client.sessionId).name + ")");
    }); 
    this.onMessage("buyItem", (client, x) => {
      const player = this.state.players.get(client.sessionId);
      console.log(x);
      var moneyRequired = 9999999999999999;
      switch (x) {
        case 1:
          moneyRequired = 10;
          break
        case 2:
          moneyRequired = 100;
          break
        case 3:
          moneyRequired = 69;
      }
      console.log(moneyRequired); 
      if (player.money >= moneyRequired) {
        player.money -= moneyRequired;
        player.items.push(x);
      }
    }); 
    this.onMessage("savePenguin", (client, x) => {
      if (!this.state.saved.includes(1)) {
        const player = this.state.players.get(client.sessionId);
        if (player.items.includes(2)) {
          this.broadcast("focus", {x: player.x - (1280 /2), y: player.y - (720 / 2), t: 3, tx: "The penguins have been saved!"});
          this.state.saved.push(1);
        } 
      }
    }); 
    this.onMessage("feed21", (client, x) => {
      if (!this.state.saved.includes(2.1)) {
        const player = this.state.players.get(client.sessionId);
        if (player.items.includes(4)) {
          this.state.saved.push(2.1);
          player.items.deleteAt(player.items.indexOf(4));
        } 
      }
    }); 
    this.onMessage("saveBear", (client, x) => {
      var fixed = parseFloat(x.toFixed(2));
      if (!this.state.saved.includes(fixed)) {
        const player = this.state.players.get(client.sessionId);
        console.log(fixed);
        if (x > 3) {
          if (x < 4) {
             this.state.saved.push(fixed);
          }
        }
      }
    }); 
    this.onMessage("feed22", (client, x) => {
      if (!this.state.saved.includes(2.2)) {
        const player = this.state.players.get(client.sessionId);
        if (player.items.includes(4)) {
          this.state.saved.push(2.2);
          player.items.deleteAt(player.items.indexOf(4));
        } 
      }
    }); 
    this.onMessage("feed23", (client, x) => {
      if (!this.state.saved.includes(2.3)) {
        const player = this.state.players.get(client.sessionId);
        if (player.items.includes(4)) {
          this.state.saved.push(2.3);
          player.items.deleteAt(player.items.indexOf(4));
        } 
      }
    }); 
    this.onMessage("endFish", (client, x) => {
      const player = this.state.players.get(client.sessionId);
      if (player.items.includes(3)) {
        player.items.push(4);
      }
    }); 
    this.onMessage("pickTrash", (client, x) => {
      const player = this.state.players.get(client.sessionId);
      if (this.state.trash.has(x.toString())) {
        player.money++;
        if (player.items.includes(1)) {
          player.money += 2;
        }
        this.state.trash.delete(x.toString());
      }
    }); 
    
    var timerdelay = 1000;
    this.setSimulationInterval(() => {
      if (this.state.saved.includes(2.1) && this.state.saved.includes(2.2) && this.state.saved.includes(2.3)) {
        if (!this.state.saved.includes(2)) {
          this.state.saved.push(2);
          this.broadcast("focus", {x: 1307-(1280/2), y: 2304-(720/2), t: 3, tx: "The seals have been fed!"});
        }
      }
      if (this.state.saved.includes(3.1) && this.state.saved.includes(3.2) && this.state.saved.includes(3.3)) {
        if (!this.state.saved.includes(3)) {
          this.state.saved.push(3);
          this.broadcast("focus", {x: 3783-(1280/2), y: 1252-(720/2), t: 3, tx: "The bears have been saved!"});
        }
      }
      timerdelay -= 16.6;
      if (timerdelay <= 0) {
        try {
        var trashLocations = [[1888,1848],[1968,1808],[2024,1792],[2072,1784],[1896,1792],[1968,1752],[1824,1816],[1784,1800],[1744,1792],[1832,1784],[1848,1760],[1904,1760],[1944,1736],[2000,1728],[2040,1728],[2096,1728],[2120,1728],[2176,1728],[2216,1728],[1696,1824],[1672,1832],[1728,1816],[1640,1864],[1608,1872],[1568,1896],[1600,1896],[1544,1920],[1520,1936],[1520,1968],[1504,1992],[1472,2024],[1448,2024],[1416,2024],[1416,2056],[1392,2088],[1448,2056],[1416,2080],[1496,2024],[1480,1992],[1552,1968],[1576,1936],[1632,1896],[1696,1872],[1760,1864],[1664,1944],[1584,2008],[1520,2056],[1448,2120],[1616,1968],[1728,1896],[1672,1904],[1864,1784],[1928,1752],[2016,1744],[2072,1728],[2152,1744],[2088,1744],[2592,2568],[2600,2664],[2632,2728],[2696,2760],[2928,2632],[2856,2504],[2608,2320],[2872,2248],[2624,2200],[2304,1168],[2248,1136],[2320,1080],[2328,2104],[2392,2032],[2248,1888],[2088,2016],[2200,2104],[2152,1952],[2144,2064],[2248,2112],[2328,2048],[2344,1976],[2192,1888],[2312,1904],[1848,2560],[1800,2632],[1800,2680],[1824,2744],[1856,2752],[1912,2760],[1848,2792],[1840,2672],[1728,2664],[1816,2576],[1776,2368],[1744,2312],[1800,2296],[1768,2256],[2160,2248],[2192,2288],[2168,2312],[2160,2360]];
        var curloc = trashLocations[Math.round(Math.random() * trashLocations.length - 1)]
        var viableSpawn = true;
        this.state.trash.forEach(function(t, k) {
          if (curloc[0] == t.x && curloc[1] == t.y) {
            viableSpawn = false;
          }
        });
        if (viableSpawn) {
          this.state.trashkey++;
          var newTrash = new Trash();
          newTrash.x = curloc[0]
          newTrash.y = curloc[1]
          this.state.trash.set(this.state.trashkey.toString(), newTrash);
        }
      } catch {}
        timerdelay = 1000;
          if (this.state.timer >= 0) {
            this.state.timer -= 1;
          }
          if (this.state.timer == 0) {
            this.state.timer = -1;
            if (this.state.state == 4) {
              this.state.state = 1;
              this.broadcast("teleporttoship")
            }
          }
      }
      var virtualReady = 0;
      this.state.players.forEach((p, k) => {
        if (p.ready)
          virtualReady++;
      });
      if (this.state.state == 0 && virtualReady >= this.state.players.size) {
          this.state.timer = 8;
          if (virtualReady == 1)
            this.state.timer = 4;
          this.state.state = 4;
      }
      if (this.state.state == 4 && virtualReady < this.state.players.size) {
        this.state.timer = -1;
        this.state.state = 0;
      } 
      this.state.readyCount = virtualReady;
    });
  }

  onJoin (client: Client, options: any) {
    console.log(client.sessionId, "joined!");
    const player = new OtherPlayer();
    this.state.players.set(client.sessionId, player);
    player.x = 0;
    player.y = 0;
  }

  onLeave (client: Client, consented: boolean) {
    console.log(client.sessionId, "left!");
    this.state.players.delete(client.sessionId);
  }

  onDispose() {
    console.log("room", this.roomId, "disposing...");
  }

}
