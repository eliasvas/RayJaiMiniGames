Spaceship :: struct {
	pos : Vector2;
	rot : float = 0.0;
	speed : float = 250.0;
	rot_speed : float = 180.0;
}


 
spaceship_update :: (using s : *Spaceship, delta : float) {
	forward_vector := Vector2Rotate(Vector2.{0,-1}, rot*DEG2RAD);
	if IsKeyDown(.KEY_UP) {
		pos = Vector2Add(pos,Vector2Scale(forward_vector, speed*delta));
	}
	if IsKeyDown(.KEY_DOWN) {
		pos = Vector2Subtract(pos,Vector2Scale(forward_vector, speed*delta));
	}
	if IsKeyDown(.KEY_RIGHT) {
		rot += rot_speed * delta;
	}
	if IsKeyDown(.KEY_LEFT) {
		rot -= rot_speed * delta;
	}

	if IsKeyPressed(.KEY_SPACE) {
		p := Projectile.{pos = s.pos, vel = Vector2Scale(forward_vector, speed*4), active = true};
		projectile_manager_spawn(*pm, p);
	}
	for *a : manager.asteroids {
		if a.active {
			if CheckCollisionCircles(pos, 10, a.pos, 10) {
				reset();
			}
		}
	}
}

spaceship_render :: (using s : *Spaceship) {
	DrawPoly(pos, 5, 20, rot - 90, RED);
}

Projectile :: struct {
	pos : Vector2;
	vel : Vector2;
	radius : float = 10;
	active : bool = false;
}



ProjectileManager :: struct {
	MAX_PROJECTILES :: 1024;
	projectiles : [MAX_PROJECTILES] Projectile;
}

projectile_manager_spawn :: (using pm : *ProjectileManager, projectile : Projectile) {
	for *p : projectiles {
		if !p.active {
			p.* = projectile;
			break;
		}
	}
}
projectile_manager_reset :: (using pm : *ProjectileManager) {
	for *p : projectiles {
		p.active = false;
	}
}

projectile_manager_update :: (using pm : *ProjectileManager, delta : float) {
	for *p : projectiles {
		if p.active {
			p.pos = Vector2Add(p.pos, Vector2Scale(p.vel, delta));
			wdim := Vector2.{cast(float)GetScreenWidth(), cast(float)GetScreenHeight()};
			
			mp_world := GetScreenToWorld2D(Vector2Divide(wdim, .{2,2}), cam);
			if Vector2Length(Vector2Subtract(p.pos , mp_world)) > Vector2Length(wdim)*cam.zoom then p.active = false;
			for *a : manager.asteroids {
				if a.active {
					if CheckCollisionCircles(p.pos, 10, a.pos, 10) {
						a.active = false;
						p.active = false;
						break;
					}
				}
			}
		}
	}
}

projectile_manager_render :: (using pm : *ProjectileManager) {
	for *p : projectiles {
		if p.active {
			DrawCircleV(p.pos, p.radius, BLUE);
		}
	}
}



