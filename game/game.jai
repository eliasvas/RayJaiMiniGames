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
	InitWindow(600, 600, "Snek+");
	SetWindowMinSize(600,600);
	SetTargetFPS(144);
	//SetWindowState(.FLAG_MSAA_4X_HINT | .FLAG_WINDOW_RESIZABLE | .FLAG_WINDOW_UNDECORATED);
	SetWindowState(.FLAG_MSAA_4X_HINT | .FLAG_WINDOW_RESIZABLE);
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
		ClearBackground(BEIGE);


		if gs != .MENU {
			w := GetScreenWidth();
			h := GetScreenHeight();
			snek_cam.offset.x = (w - 600)/2.0;
			snek_cam.offset.y = (h - 600)/2.0;
			snek_cam.zoom = 1.0; //cast(float)(min(w,h) / 600.0);
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
