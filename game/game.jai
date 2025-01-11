#import "Basic";
#import "String";
#import "File";
#import "raylib";
#import "Math";
#load "entity.jai";
#load "misc.jai";

snek : *Snek;
text : FunkyText;

main :: () {
	InitWindow(600, 400, "Hello Raylib!");
	SetTargetFPS(60);
	snek = make_entity(Snek);
	funkytext_set_menu(*text);

	while !WindowShouldClose(){
		if IsKeyDown(.KEY_A) then funkytext_set_menu(*text);
		if IsKeyDown(.KEY_SPACE) then funkytext_set_ingame(*text);
		

		BeginDrawing();
		ClearBackground(RAYWHITE);
		funkytext_render(*text);
		EndDrawing();

	}
}
