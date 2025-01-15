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
	funkytext_set_menu(*text);
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

snek_get_first_tail_tile :: (using snek : *Snek) -> iv2 {
	if tail.count == 0 then return tile;
	return tail[0];
}


snek_get_last_tail_tile :: (using snek : *Snek) ->iv2 {
	if tail.count == 0 then return tile;
	return tail[tail.count-1];
}

snek_get_prev_to_last_tail_tile :: (using snek : *Snek) ->iv2 {
	if tail.count == 0 then return tile;
	if tail.count == 1 then return tail[0];
	return tail[tail.count-2];
}
snek_get_new_tails_tile :: (using snek : *Snek, actual_move_dir : iv2) ->iv2 {
	if tail.count == 0 then return .{tile.x -actual_move_dir.x, tile.y-actual_move_dir.y};
	lt := snek_get_last_tail_tile(snek);
	ptlt := snek_get_prev_to_last_tail_tile(snek);
	md := iv2.{ptlt.x - lt.x, ptlt.y - lt.y};
	return iv2.{lt.x - md.x, lt.y - md.y};
}

to_ss :: (tile : Vector2) ->Vector2{
	v := Vector2.{cast(float)(fmod_cycling(tile.x, MAP_DIM)), cast(float)(fmod_cycling(tile.y, MAP_DIM))};
	if tile.x < 0 then v.x = MAP_DIM + v.x;
	if tile.y < 0 then v.y = MAP_DIM + v.y;
	return v;
}

to_ss :: (tile : iv2) ->iv2 {
	v := iv2.{tile.x % MAP_DIM, tile.y % MAP_DIM};
	if tile.x < 0 then v.x = MAP_DIM + v.x;
	if tile.y < 0 then v.y = MAP_DIM + v.y;
	return v;
}

TIME_PER_MOVE :: 0.1;
move_timer :float = TIME_PER_MOVE;

snek_update :: (snek : *Snek) {
	if gs == .MENU then return;
	if IsKeyDown(.KEY_UP) || IsKeyDown(.KEY_K) then move_dir = .{0,-1};
	if IsKeyDown(.KEY_DOWN) || IsKeyDown(.KEY_J) then move_dir = .{0,1};
	if IsKeyDown(.KEY_LEFT) || IsKeyDown(.KEY_H) then move_dir = .{-1,0};
	if IsKeyDown(.KEY_RIGHT) || IsKeyDown(.KEY_L) then move_dir = .{1,0};
	move_timer -= GetFrameTime();
	if move_timer < 0.0 {
		for < *tail,idx : snek.tail {
			if idx == 0 then tail.* = snek.tile;
			else tail.* = snek.tail[idx-1];
		}
		snek.tile.x += move_dir.x;
		snek.tile.y += move_dir.y;
		move_timer = TIME_PER_MOVE;
	}

	for t,idx : snek.tail { if iv2_isect(to_ss(snek.tile), to_ss(t)) { lose(); return; } }

	idx_to_delete := -1;
	for f,idx : food {
		if iv2_isect(to_ss(snek.tile), to_ss(f.tile)) {
			idx_to_delete = idx;
			// eat food
			new_tail_piece := snek_get_new_tails_tile(snek, move_dir);
			array_add(*snek.tail, new_tail_piece);
		}
	}
	if idx_to_delete != -1 {
		food[idx_to_delete] = food[food.count-1];
		food.count-=1;
	}
	// if head collides with tail we lose
}

snek_render :: (snek : *Snek) {
	entity_draw_smooth_head(.{cast(float)snek.tile.x,cast(float)snek.tile.y});
	if snek.tail.count > 0 { 
		ft := snek_get_first_tail_tile(snek);
		mtile : Vector2;
		mtile.x = xx ((snek.tile.x - ft.x) / 2.0);
		mtile.x += ft.x;
		mtile.y = xx ((snek.tile.y - ft.y) / 2.0);
		mtile.y += ft.y;

		entity_draw_smooth_head(.{cast(float)mtile.x,cast(float)mtile.y});
	}

	if snek.tail.count > 0 { 
	lt := snek_get_last_tail_tile(snek);
	ptlt := snek_get_prev_to_last_tail_tile(snek);
		mtile : Vector2;
		mtile.x = xx (-(lt.x - ptlt.x) / 2.0);
		mtile.x += lt.x;
		mtile.y = xx (-(lt.y - ptlt.y) / 2.0);
		mtile.y += lt.y;

		entity_draw_smooth_head(.{cast(float)mtile.x,cast(float)mtile.y});
	}


	for t,idx : snek.tail {
		if idx == snek.tail.count-1 continue;
		ent : Snek = snek.*;
		ent.tile = t;
		entity_draw(*ent);
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
CELL_SIZE :: 45;
entity_draw :: (e : *Entity) {
	tile := to_ss(e.tile);
	color := e.color;
	if e.type == Food {
		DrawCircle(cast(s32)(tile.x)*TILE_MODIFIER+cast(s32)((0.5)*TILE_MODIFIER),cast(s32)(tile.y)*TILE_MODIFIER+cast(s32)((0.5)*TILE_MODIFIER),CELL_SIZE/2,color);
	}else {
		DrawRectangle(cast(s32)tile.x*TILE_MODIFIER,cast(s32)tile.y*TILE_MODIFIER,ENTITY_SIZE_IN_PX,ENTITY_SIZE_IN_PX,color);
	}
}

entity_draw_smooth_head :: (t:Vector2) {
	tile := to_ss(t);
	color := RED;
	DrawRectangleRounded(Rectangle.{cast(float)tile.x*TILE_MODIFIER,cast(float)tile.y*TILE_MODIFIER,ENTITY_SIZE_IN_PX,ENTITY_SIZE_IN_PX}, 0.5, 4,color);
}



MAP_DIM :: 12;
draw_map :: () {
  for tile_x : 0..MAP_DIM-1{
    for tile_y : 0..MAP_DIM-1{
      coord := ifx tile_y % 2 == 0 then tile_x else tile_x + 1;
      color := ifx coord % 2 == 0 then GRAY else WHITE;
      color2 := BEIGE;
      padding := cast(s32)(TILE_MODIFIER - (CELL_SIZE + 2 * sin(GetTime()*10)));
      DrawRectangle(cast(s32)tile_x*TILE_MODIFIER,cast(s32)tile_y*TILE_MODIFIER,ENTITY_SIZE_IN_PX,ENTITY_SIZE_IN_PX,color2);
      DrawRectangle(cast(s32)tile_x*TILE_MODIFIER + padding,cast(s32)tile_y*TILE_MODIFIER+padding,ENTITY_SIZE_IN_PX-2*padding,ENTITY_SIZE_IN_PX-2*padding,color);
    }
  }
}
