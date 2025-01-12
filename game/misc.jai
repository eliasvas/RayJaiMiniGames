#import "Math";

/////////////////////////////////
// Funky Text
/////////////////////////////////

FunkyText :: struct {
	text : string;
	rotation : float;
	rot_mod :float = 7.0;

	target_pos : Vector2;
	pos : Vector2;
	delta : float = 1.0;
};

funkytext_set_ingame :: (t : *FunkyText, reset_animations : bool = true) {
	using t;
	rot_mod = 6.0;
	text = "Try Not to Die!";
	target_pos = Vector2.{GetScreenWidth()/2.0,20};
	if reset_animations then delta = 0.0;
}

funkytext_set_menu :: (t : *FunkyText, reset_animations : bool = true) {
	using t;
	rot_mod = 7.0;
	text = "Press Space to Play!";
	target_pos = Vector2.{GetScreenWidth()/2.0,GetScreenHeight()/2.0};
	if reset_animations then delta = 0.0;
}

funkytext_render :: (t : *FunkyText) {
	using t;
	FONT_SIZE :: 40;
	delta = min(1.0, delta+GetFrameTime());
	col := LIGHTGRAY;
	pos = pos + (target_pos - pos)*delta;

	dim := MeasureText(text.data, FONT_SIZE);
	//DrawTextPro(GetFontDefault(), text.data, xx .{(windim.x-dim)/2, 20}, xx .{(windim.x-dim)/2, 20}, 0, 40, 5,LIGHTGRAY);
	posi := Vector2.{GetScreenWidth()/2.0,20};
	origin := Vector2.{dim/2.0,0};
	DrawTextPro(GetFontDefault(), text.data,pos,origin,cast(float)sin(GetTime()*rot_mod)*5.0, FONT_SIZE, 5,LIGHTGRAY);
}



/////////////////////////////////
// Game State
/////////////////////////////////

GameState :: enum {
	MENU;
	MAKE_MOVE;
};


