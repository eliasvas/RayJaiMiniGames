#import "Basic";
#import "String";
#import "File";
#import "raylib";
#import "Math";
#import "Random";
#load "entity.jai";
#load "misc.jai";

score : s32;

snek : *Snek;
snek_cam : Camera2D;

text : FunkyText;
score_text : FunkyText;

gs : GameState = .MENU;

main :: () {
	InitWindow(600, 400, "Hello Raylib!");
	init();
	SetTargetFPS(60);
	snek = make_entity(Snek);
	snek_cam.zoom = 1;
	funkytext_set_menu(*text, false);

	while !WindowShouldClose(){
		funkytext_set_score(*score_text, false);
		if IsKeyDown(.KEY_A) {
			init();
			snek = make_entity(Snek);
			score = 0;
			gs = .MENU;
			funkytext_set_menu(*text);
		}
		if IsKeyDown(.KEY_SPACE) {
			gs = .MAKE_MOVE;
			funkytext_set_ingame(*text);
		}
		if IsKeyPressed(.KEY_N) {
			coin := make_entity(Coin);
			coin.tile_x = cast(u32)(random_get() % MAP_DIM);
			coin.tile_y = cast(u32)(random_get() % MAP_DIM);
			coin.color = BROWN;
		}
		

		BeginDrawing();
		ClearBackground(RAYWHITE);


		if gs != .MENU {
			update_entities();
			//snek_cam.target = Vector2.{cast(float)snek.tile_x*TILE_MODIFIER + ENTITY_SIZE_IN_PX/2.0 - GetScreenWidth()/2.0,cast(float)snek.tile_y*TILE_MODIFIER + ENTITY_SIZE_IN_PX/2.0 - GetScreenHeight()/2.0};
			snek_cam.target = Vector2.{0,0};
			BeginMode2D(*snek_cam);

			draw_map();
			draw_entities();
		}

		EndMode2D();



		funkytext_render(*text);
		funkytext_render(*score_text);
		EndDrawing();
		end_frame();
	}
}
