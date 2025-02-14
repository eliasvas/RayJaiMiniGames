#import "Math";
#import "Basic";
#import "String";
#import "File";
#import "Math";
#import "Random";
#import "raylib5";

#load "gui.jai";

panel : Panel;

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
	panel = Panel.{
		x = 100,
		y = 100,
		width = 200,
		title = "MyPanel",
	};
}

update :: () {
	gui_update();
}

render :: () {
	wdim := Vector2.{cast(float)GetScreenWidth(), cast(float)GetScreenHeight()};
	BeginDrawing();
	ClearBackground(BLACK);
	gui_test_panel(*panel);
	EndDrawing();
}

