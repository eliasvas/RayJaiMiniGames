Vector2Rotate :: (v: Vector2, angle: float) -> Vector2 #foreign raylib_native;
Vector2Add :: (v1: Vector2, v2: Vector2) -> Vector2 #foreign raylib_native;
Vector2Subtract :: (v1: Vector2, v2: Vector2) -> Vector2 #foreign raylib_native;
Vector2Divide :: (v1: Vector2, v2: Vector2) -> Vector2 #foreign raylib_native;
Vector2Normalize :: (v: Vector2) -> Vector2 #foreign raylib_native;


Asteroid :: struct {
	pos : Vector2;
	vel : Vector2;
	rot : float;
	rot_per_sec : float;
	active : bool;
}


asteroid_make :: (p : Vector2, v : Vector2 = .{10,0}) ->Asteroid {
	a := Asteroid.{pos = p};
	a.active = true;
	a.rot = cast(float)GetRandomValue(0,360);
	a.rot_per_sec = cast(float)GetRandomValue(0,100);
	//a.vel = Vector2.{cast(float)GetRandomValue(0,20), 0};
	a.vel = v;

	return a;
}
asteroid_render:: (using a : *Asteroid) {
	DrawPolyLines(pos, 3, 20, rot, RAYWHITE);
}
asteroid_update :: (using a : *Asteroid, delta : float) {
	if active {
		pos += vel * delta;
		rot += rot_per_sec * delta;
	}
}


AsteroidManager :: struct {
	spawn_radius : float;
	MAX_ASTEROIDS :: 1024 * 1000;
	asteroids : [MAX_ASTEROIDS]Asteroid;
}

asteroid_manager_clear :: (using manager : *AsteroidManager) {
	for *a : asteroids {
		a.active = false;
	}
}
asteroid_manager_render :: (using manager : *AsteroidManager) {
	for *a : asteroids {
		if a.active {
			asteroid_render(a);
		}
	}
}

asteroid_manager_update :: (using manager : *AsteroidManager, delta : float) {
	for *a : asteroids {
		if a.active {
			asteroid_update(a, delta);
		}
	}
}

asteroid_manager_add :: (using manager : *AsteroidManager, a : Asteroid) {
	for *a_slot, idx : asteroids {
		if !a_slot.active {
			a_slot.* = a;
			break;
		}
	} 
}


asteroid_manager_spawn :: (using manager : *AsteroidManager) {
	wdim := Vector2.{cast(float)GetScreenWidth(), cast(float)GetScreenHeight()};
	if IsMouseButtonDown(0) { 
		pos := Vector2.{cast(float)GetRandomValue(0,cast(s32)wdim.x), cast(float)GetRandomValue(0, cast(s32)wdim.y)};
		// todo: collapse this to edges
		point := Vector2Rotate(Vector2.{cast(float)GetRandomValue(0,cast(s32)spawn_radius),0.0}, cast(float)GetRandomValue(0, 360));
		point = Vector2Add(Vector2Subtract(Vector2Divide(wdim, .{2,2}), point), pos);
		vel := Vector2Normalize(Vector2Subtract(pos,point)) * 10;

		asteroid_manager_add(manager, asteroid_make(pos, vel));
	}
}