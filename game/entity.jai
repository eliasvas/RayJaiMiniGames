#import "Basic";
#import "Math";

Entity :: struct {
  type: Type;
  slot: int;
  tile_x : u32;
  tile_y : u32;
  color : Color = RED;
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
  ini :: initializer_of(T);
  if ini then ini(result);
  else memset(result, 0, size_of(type_of(T)));
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
      //freelist_cursor -= 1;
      //freelist[freelist_cursor] = e.slot;
      e.slot = -1;
    }
  }
}

draw_entities :: () {
  for *entity_slot: all_entities {
    e := cast(*Entity)entity_slot;
    if e.slot < 0 then continue;
    entity_draw(e);
  }
}

handle_collision :: (e : *Entity, e2 : *Entity) {
    if e.type == {
      case Snek;
        if e2.type == {
          case Coin;
            destroy_entity(e2);
            score+=1;
          case;
        }
      case Coin;
        if e2.type == {
          case Snek;
            destroy_entity(e);
            score+=1;
          case;
        }
      case PowerUp;
      case;
    }
}

lpk : KeyboardKey = .KEY_LEFT;
update_entities :: () {
  if IsKeyPressed(.KEY_UP) then lpk = .KEY_UP;
  if IsKeyPressed(.KEY_DOWN) then lpk = .KEY_DOWN;
  if IsKeyPressed(.KEY_LEFT) then lpk = .KEY_LEFT;
  if IsKeyPressed(.KEY_RIGHT) then lpk = .KEY_RIGHT;
  for *entity_slot: all_entities {
    e := cast(*Entity)entity_slot;
    if e.slot < 0 then continue;
    if e.marked_for_destruction then continue;
    // perform collision checks and resolve if necessary!
    for *entity_slot2: all_entities {
      e2 := cast(*Entity)entity_slot2;
      if e2.slot < 0 then continue;
      if e2 != e && e.tile_x == e2.tile_x && e.tile_y == e2.tile_y {
        handle_collision(e, e2);
      }
    }
    if e.type == {
      case Snek;
        if gs == .MAKE_MOVE {
          if lpk == .KEY_UP then e.tile_y -=1;
          if lpk == .KEY_DOWN then e.tile_y +=1;
          if lpk == .KEY_LEFT then e.tile_x -=1;
          if lpk == .KEY_RIGHT then e.tile_x +=1;
        }
      case Coin;
      case PowerUp;
      case;
    }
    // do entity specific updates
    entity_draw(e);
  }
}



ENTITY_SIZE_IN_PX :: 50;
TILE_MODIFIER :: 50;
entity_draw :: (using e : *Entity) {
  DrawRectangle(cast(s32)tile_x*TILE_MODIFIER,cast(s32)tile_y*TILE_MODIFIER,ENTITY_SIZE_IN_PX,ENTITY_SIZE_IN_PX,color);
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

MAP_DIM :: 16;
draw_map :: () {
  for tile_x : 0..MAP_DIM-1{
    for tile_y : 0..MAP_DIM-1{
      coord := ifx tile_y % 2 == 0 then tile_x else tile_x + 1;
      color := ifx coord % 2 == 0 then GRAY else WHITE;
      DrawRectangle(cast(s32)tile_x*TILE_MODIFIER,cast(s32)tile_y*TILE_MODIFIER,ENTITY_SIZE_IN_PX,ENTITY_SIZE_IN_PX,color);
    }
  }
}
