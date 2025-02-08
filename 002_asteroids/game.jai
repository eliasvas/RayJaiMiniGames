#import "Math";
#import "Basic";
#import "String";
#import "File";
#import "Math";
#import "Random";
#import "raylib";

Vector2Rotate :: (v: Vector2, angle: float) -> Vector2 #foreign raylib_native;
Vector2Scale :: (v: Vector2, angle: float) -> Vector2 #foreign raylib_native;
Vector2Add :: (v1: Vector2, v2: Vector2) -> Vector2 #foreign raylib_native;
Vector2Subtract :: (v1: Vector2, v2: Vector2) -> Vector2 #foreign raylib_native;
Vector2Divide :: (v1: Vector2, v2: Vector2) -> Vector2 #foreign raylib_native;
Vector2Normalize :: (v: Vector2) -> Vector2 #foreign raylib_native;
Vector2Length :: (v: Vector2) -> float #foreign raylib_native;

#load "asteroid.jai";
manager : AsteroidManager;

#load "spaceship.jai";
spaceship : Spaceship;
pm : ProjectileManager;

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
	reset();
}
reset :: () {
	asteroid_manager_reset(*manager);
	projectile_manager_reset(*pm);
	wdim := Vector2.{cast(float)GetScreenWidth(), cast(float)GetScreenHeight()};
	spaceship.pos = Vector2Divide(wdim, .{2,2});
}
update :: () {
	//if IsMouseButtonDown(0) { asteroid_manager_add(*manager, asteroid_make(GetMousePosition())); }

	asteroid_manager_spawn(*manager);
	asteroid_manager_update(*manager, GetFrameTime());
	projectile_manager_update(*pm, GetFrameTime());
	spaceship_update(*spaceship, GetFrameTime());
}
render :: () {
	BeginDrawing();
	ClearBackground(SKYBLUE);
	asteroid_manager_render(*manager);
	projectile_manager_render(*pm);
	spaceship_render(*spaceship);
	EndDrawing();
}

