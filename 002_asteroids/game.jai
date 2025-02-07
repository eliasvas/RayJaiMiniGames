#import "Math";
#import "Basic";
#import "String";
#import "File";
#import "Math";
#import "Random";
#import "raylib";

#load "asteroid.jai";
manager : AsteroidManager;


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
	asteroid_manager_clear(*manager);
}

update :: () {
	if IsKeyDown(.KEY_SPACE) {
		exit(1);
	}
	//if IsMouseButtonDown(0) { asteroid_manager_add(*manager, asteroid_make(GetMousePosition())); }

	asteroid_manager_spawn(*manager);
	asteroid_manager_update(*manager, GetFrameTime());
}
render :: () {
	BeginDrawing();
	ClearBackground(SKYBLUE);
	asteroid_manager_render(*manager);
	EndDrawing();
}

