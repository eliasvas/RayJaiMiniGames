#import "Basic";
#import "String";
#import "File";
#import "raylib";
#import "Math";

windim := Vector2.{600,400};
font_size :s32= 40;
main :: () {
	InitWindow(xx windim.x, xx windim.y, "Hello Raylib!");
	exit_loop := false;
	while !exit_loop && !WindowShouldClose(){
		exit_loop = IsKeyDown(.KEY_SPACE);

		BeginDrawing();
		ClearBackground(RAYWHITE);
		text := "Press Space to Exit!";
		dim := MeasureText(text.data, font_size);
		DrawText(text.data, cast(s32) (windim.x-dim)/2, cast (s32) (windim.y)/2, font_size, LIGHTGRAY);
		DrawFPS(0,0);
		EndDrawing();
	}
}
