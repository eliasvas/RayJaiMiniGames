

GUI_INVALID_ID :: 666;
GuiState :: struct {
	hot : u32;
	active : u32;
	CONTROL_COLOR :: LIGHTGRAY;
	HOT_COLOR :: GRAY;
	ACTIVE_COLOR :: DARKGRAY;
}
gui_state : GuiState;

gui_init :: () {
	using gui_state;
	hot = GUI_INVALID_ID; // where we hover
	active = GUI_INVALID_ID; // where we interact(ed)
}
gui_update :: () {
	using gui_state;
	//print("hot: %, active: %\n", gui_state.hot, gui_state.active);
	hot = GUI_INVALID_ID;
}


gui_button :: (id : u32, text : string, coords : Rectangle) -> bool {
	res : bool;
	if CheckCollisionPointRec(GetMousePosition(), coords) {
		gui_state.hot = id;
	}
	if gui_state.hot == id && IsMouseButtonPressed(0) {
		gui_state.active = id;
	}

	if gui_state.hot == id && gui_state.active == id && IsMouseButtonReleased(0) {
		res = true;
		gui_state.active = GUI_INVALID_ID;
	}else if gui_state.active == id && IsMouseButtonReleased(0) {
		gui_state.active = GUI_INVALID_ID;
	}
	color : Color = ifx gui_state.active == id then GuiState.ACTIVE_COLOR else ifx gui_state.hot == id then GuiState.HOT_COLOR else GuiState.CONTROL_COLOR;
	DrawRectangleRounded(coords,0.2, 10, color);
	font := GetFontDefault();
	text_w := MeasureText(text.data, 100);
	DrawText(text.data, cast(s32)coords.x - cast(s32)((text_w - coords.width)/2.0), cast(s32)coords.y + 50, 100, RAYWHITE);
	return res;
}

