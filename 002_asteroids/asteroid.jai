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
	spawn_radius : float =100.0;
	MAX_ASTEROIDS :: 1024 * 1000;
	asteroids : [MAX_ASTEROIDS]Asteroid;
}

asteroid_manager_render :: (using manager : *AsteroidManager) {
	for *a : asteroids {
		if a.active {
			asteroid_render(a);
		}
	}
}

asteroid_manager_reset :: (using manager : *AsteroidManager) {
	for *a : asteroids {
		a.active = false;
	}
}

asteroid_manager_update :: (using manager : *AsteroidManager, delta : float) {
	for *a : asteroids {
		if a.active {
			asteroid_update(a, delta);

			wdim := Vector2.{cast(float)GetScreenWidth(), cast(float)GetScreenHeight()};
			mp_world := GetScreenToWorld2D(Vector2Divide(wdim, .{2,2}), cam);
			if Vector2Length(Vector2Subtract(a.pos , mp_world)) > Vector2Length(wdim)*cam.zoom then a.active = false;
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

collapse_position :: (pos : Vector2, bounds : Vector2) -> Vector2{
	p := pos;
	if GetRandomValue(0,1) > 0 {
		if GetRandomValue(0,1) > 0 {
			p.x = 0;
		}else {
			p.x = bounds.x;
		}
	}else {
		if GetRandomValue(0,1) > 0 {
			p.y = 0;
		}else {
			p.y = bounds.y;
			
		}
	}
	return p;
}

asteroid_manager_spawn :: (using manager : *AsteroidManager) {
	wdim := Vector2.{cast(float)GetScreenWidth(), cast(float)GetScreenHeight()};
	if GetRandomValue(0,60) == 0 { 
		pos := Vector2.{cast(float)GetRandomValue(0,cast(s32)wdim.x), cast(float)GetRandomValue(0, cast(s32)wdim.y)};
		pos = collapse_position(pos, wdim);
		point := Vector2Rotate(Vector2.{cast(float)GetRandomValue(0,cast(s32)spawn_radius),0.0}, cast(float)GetRandomValue(0, 360));
		point = Vector2Subtract(Vector2Add(Vector2Divide(wdim, .{2,2}), point), pos);
		vel := Vector2Normalize(point) * 100;

		world_pos := GetScreenToWorld2D(pos, cam);

		asteroid_manager_add(manager, asteroid_make(world_pos, vel));
	}
}