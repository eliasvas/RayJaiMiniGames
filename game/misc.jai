#import "Math";
FunkyText :: struct {
	text : string;
	rotation : float;

	target_pos : Vector2;
	pos : Vector2;
	delta : float = 1.0;
};

funkytext_set_ingame :: (t : *FunkyText) {
	using t;
	text = "Try Not to Die!";
	target_pos = Vector2.{GetScreenWidth()/2.0,20};
	delta = 0.0;
}

funkytext_set_menu :: (t : *FunkyText) {
	using t;
	text = "Press Space to Play!";
	target_pos = Vector2.{GetScreenWidth()/2.0,GetScreenHeight()/2.0};
	delta = 0.0;
}

funkytext_render :: (t : *FunkyText) {
	using t;
	FONT_SIZE :: 40;
	delta += GetFrameTime();
	col := LIGHTGRAY;
	pos = pos + (target_pos - pos) * delta;

	dim := MeasureText(text.data, FONT_SIZE);
	//DrawTextPro(GetFontDefault(), text.data, xx .{(windim.x-dim)/2, 20}, xx .{(windim.x-dim)/2, 20}, 0, 40, 5,LIGHTGRAY);
	posi := Vector2.{GetScreenWidth()/2.0,20};
	origin := Vector2.{dim/2.0,0};
	DrawTextPro(GetFontDefault(), text.data,pos,origin,cast(float)sin(GetTime()*7)*5.0, FONT_SIZE, 5,LIGHTGRAY);
}

