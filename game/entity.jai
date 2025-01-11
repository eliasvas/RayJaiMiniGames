#import "Basic";
#import "Math";

Entity :: struct {
  type: Type;
  slot: int;
  //position: Vector2;
  tile_x : u32;
  tile_y : u32;
  marked_for_destruction : bool;
}

LARGEST_ENTITY_SIZE :: #run -> int {
  result := size_of(Entity);
  result = max(result, size_of(Snek));
  result = max(result, size_of(PowerUp));
  result = max(result, size_of(Coin));
  return result;
};

MAX_ENTITIES :: 1024;
all_entities: [MAX_ENTITIES][LARGEST_ENTITY_SIZE]u8;
freelist: [MAX_ENTITIES]int;
freelist_cursor: int;

init :: () {
  for 0..freelist.count-1 {
    freelist[it] = it; // make freelist be: [0, 1, 2, 3, ..., 1021, 1022, 1023]
  }
  for 0..all_entities.count-1 {
    e := cast(*Entity)*all_entities[it];
    e.slot = -1; // all entities invalid by default
  }
}

make_entity :: ($T: Type) -> *T {
  assert(freelist_cursor < freelist.count); // made too many entities! bump up MAX_ENTITIES.
  index := freelist[freelist_cursor];
  freelist_cursor += 1;
  result := cast(*T)*all_entities[index];
  //ini :: initializer_of(T);
  //if ini then ini(result);
  memset(result, 0, size_of(type_of(T)));
  result.type = T;
  return result;
}

destroy_entity :: (e: *Entity) {
  assert(e.slot >= 0); // catch double-destroy
  e.marked_for_destruction = true;
}

end_frame :: () {
  for *entity_slot: all_entities {
    e := cast(*Entity)entity_slot;
    if e.slot < 0 then continue;
    if e.marked_for_destruction {
      assert(freelist_cursor > 0); // should never happen
      assert(e.slot >= 0); // catch double-destroys
      freelist_cursor -= 1;
      freelist[freelist_cursor] = e.slot;
    }
  }
}



// SNAKE LOGIC

Snek :: struct {
  using #as base: Entity;
}


// POWERUP LOGIC

PowerUpKind :: enum {
  SPEEDX2;
  SPEEDX05;
  INVINCIBILITY;
  GETALLCOINS;
}

PowerUp :: struct {
  using #as base: Entity;
  kind : PowerUpKind;
  duration : float;
}

// COIN LOGIC

Coin :: struct {
  using #as base: Entity;
}

// MAP LOGIC

Map :: struct {
  MAP_DIM :: 32;
}
