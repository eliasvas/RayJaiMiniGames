#import "Math";
#import "Basic";
#import "String";
#import "File";
#import "Math";
#import "Random";
#import "raylib5";

#load "asteroid.jai";
manager : AsteroidManager;

#load "spaceship.jai";
spaceship : Spaceship;
pm : ProjectileManager;
cam : Camera2D; 	

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
	spaceship.pos = Vector2.{};
}
update :: () {
	//if IsMouseButtonDown(0) { asteroid_manager_add(*manager, asteroid_make(GetMousePosition())); }

	asteroid_manager_spawn(*manager);
	asteroid_manager_update(*manager, GetFrameTime());
	projectile_manager_update(*pm, GetFrameTime());
	spaceship_update(*spaceship, GetFrameTime());
}
render :: () {

	wdim := Vector2.{cast(float)GetScreenWidth(), cast(float)GetScreenHeight()};
	cam = Camera2D.{offset = Vector2Divide(wdim, .{2,2}), target = spaceship.pos, rotation = -spaceship.rot, zoom = 1.0};
	BeginDrawing();
	BeginMode2D(cam);
	ClearBackground(SKYBLUE);
	asteroid_manager_render(*manager);
	projectile_manager_render(*pm);
	spaceship_render(*spaceship);
	EndMode2D();
	EndDrawing();
}

