#import "Basic";
#import "String";
#import "File";
#import "raylib";
#import "Math";
#import "Random";
#load "misc.jai";
#load "entities.jai";


snek_cam : Camera2D;

text : FunkyText;

gs : GameState = .MENU;

main :: () {
	InitWindow(600, 400, "Hello Raylib!");
	SetTargetFPS(60);
	snek_cam.zoom = 1;
	funkytext_set_menu(*text, false);

	while !WindowShouldClose(){
		if IsKeyDown(.KEY_A) {
			lose();
		}

		if IsKeyDown(.KEY_SPACE) {
			gs = .MAKE_MOVE;
			funkytext_set_ingame(*text);
		}
		food_update();
		snek_update(*snek);
		

		BeginDrawing();
		ClearBackground(RAYWHITE);


		if gs != .MENU {
			//snek_cam.target = Vector2.{cast(float)snek.tile_x*TILE_MODIFIER + ENTITY_SIZE_IN_PX/2.0 - GetScreenWidth()/2.0,cast(float)snek.tile_y*TILE_MODIFIER + ENTITY_SIZE_IN_PX/2.0 - GetScreenHeight()/2.0};
			snek_cam.target = Vector2.{0,0};
			BeginMode2D(*snek_cam);

			draw_map();
			food_render();
			snek_render(*snek);
		}

		EndMode2D();



		funkytext_render(*text);
		EndDrawing();
	}
}
