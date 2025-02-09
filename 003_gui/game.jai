#import "Math";
#import "Basic";
#import "String";
#import "File";
#import "Math";
#import "Random";
#import "raylib5";

#load "gui.jai";

main :: () {
	init();
	while !WindowShouldClose() {
		update();
		render();
	}
}

init :: () {
	SetWindowState(.FLAG_WINDOW_RESIZABLE | .FLAG_WINDOW_ALWAYS_RUN);
	SetTargetFPS(144);
	InitWindow(600, 600, "Snek+");

	SetRandomSeed(xx GetTime());
	gui_init();
}

update :: () {
	gui_update();
}
render :: () {
	wdim := Vector2.{cast(float)GetScreenWidth(), cast(float)GetScreenHeight()};
	BeginDrawing();
	ClearBackground(SKYBLUE);
	if gui_button(10, "Doom", .{5,100,405,200}) then print("Doom triggered!\n");
	if gui_button(12, "Boop", .{400,400,100,200}) then print("Boop triggered!\n");
	EndDrawing();
}

