#import "Math";

iv2 :: struct {
	x : s32;
	y : s32;
}

Entity :: struct {
  type: Type;
	tile : iv2;
  color : Color = WHITE;
}

Snek :: struct {
  using #as base: Entity;
	tail : [..]iv2;
	type = Snek;
	color = RED;
}
snek : Snek;
move_dir := iv2.{0,0};

lose :: () {
	reset_scene :: () {
		array_reset(*snek.tail);
		snek.tile = .{0,0};
		move_dir = .{0,0};
		array_reset(*food);
	}
	gs = .MENU;
	reset_scene();
	funkytext_set_ingame(*text);
}

iv2_isect :: (a : iv2, b : iv2) -> bool { return a.x == b.x && a.y == b.y; }


TIME_PER_NEW_FOOD :: 0.5;
new_food_timer :float = TIME_PER_NEW_FOOD;
food_update :: () {
	new_food_timer -= GetFrameTime();
	if new_food_timer < 0.0 {
		f : Food;
		f.tile.x = cast(s32)(random_get() % MAP_DIM);
		f.tile.y = cast(s32)(random_get() % MAP_DIM);
		array_add(*food, f);
		new_food_timer = TIME_PER_NEW_FOOD; 
	}
}
food_render :: () {
	for f : food {
		entity_draw(f);
	}
}


TIME_PER_MOVE :: 0.1;
move_timer :float = TIME_PER_MOVE;

snek_update :: (snek : *Snek) {
	if gs == .MENU then return;
	if IsKeyDown(.KEY_UP) then move_dir = .{0,-1};
	if IsKeyDown(.KEY_DOWN) then move_dir = .{0,1};
	if IsKeyDown(.KEY_LEFT) then move_dir = .{-1,0};
	if IsKeyDown(.KEY_RIGHT) then move_dir = .{1,0};
	move_timer -= GetFrameTime();
	if move_timer < 0.0 {
		for < *tail,idx : snek.tail {
			if idx == 0 then tail.* = snek.tile;
			else tail.* = snek.tail[idx-1];
		}
		//move
		snek.tile.x += move_dir.x;
		snek.tile.y += move_dir.y;
		//reset
		move_timer = TIME_PER_MOVE;
	}
	idx_to_delete := -1;
	for f,idx : food {
		if iv2_isect(snek.tile, f.tile) {
			idx_to_delete = idx;
			// eat food
			new_tail_piece := ifx snek.tail.count == 0 then snek.tile else snek.tail[snek.tail.count-1];
			new_tail_piece.x -= move_dir.x;
			new_tail_piece.y -= move_dir.y;
			//array_add(*snek.tail, new_tail_piece);
		}
	}
	if idx_to_delete != -1 {
		food[idx_to_delete] = food[food.count-1];
		food.count-=1;
	}
	// if head collides with tail we lose
}

snek_render :: (snek : *Snek) {
	entity_draw(snek);
	ent := snek;
	for t : snek.tail {
		ent.tile = t;
		entity_draw(ent);
	}
}

Food :: struct {
  using #as base: Entity;
	type = Food;
	color = BROWN;
}
food : [..] Food;

ENTITY_SIZE_IN_PX :: 50;
TILE_MODIFIER :: 50;
entity_draw :: (using e : *Entity) {
  DrawRectangle(cast(s32)tile.x*TILE_MODIFIER,cast(s32)tile.y*TILE_MODIFIER,ENTITY_SIZE_IN_PX,ENTITY_SIZE_IN_PX,color);
}


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
