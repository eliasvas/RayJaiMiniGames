

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
	print("hot: %, active: %\n", gui_state.hot, gui_state.active);
	if hot != active && IsMouseButtonReleased(0) then active = GUI_INVALID_ID;
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
	text_height := cast(float)(coords.height * 0.8);
	font := GetFontDefault();
	text_w := MeasureText(text.data, cast(s32)text_height);
	DrawText(text.data, cast(s32)coords.x - cast(s32)((text_w - coords.width)/2.0), cast(s32)(coords.y + text_height/4), cast(s32)text_height, RAYWHITE);
	return res;
}

PanelLayout :: struct {
	width : float;
	row_height : float;
	at_x : float;
	at_y : float;
	ypad : s32 = 5;

	DEF_ROW_HEIGHT :: 70;
	TITLE_HEIGHT :: 100;
}

panel_layout_advance_row :: (using layout : *PanelLayout) {
	at_y += row_height;
}
panel_layout_add_title :: (using layout : *PanelLayout, title : string) {
	DrawText(title.data, cast(s32)at_x, cast(s32)at_y, TITLE_HEIGHT, RAYWHITE);
	at_y += TITLE_HEIGHT;
}


gui_test_panel :: (x : float, y : float, w : float, h : float) {
	title_text :string= "TestPanel";
	layout := PanelLayout.{
		at_x = x,
		at_y = y,
		row_height = PanelLayout.DEF_ROW_HEIGHT,
		width = w,
	};
	num_categories := 2;
	total_height := num_categories * (layout.row_height+layout.ypad) + PanelLayout.TITLE_HEIGHT;
	DrawRectangle(cast(s32)x, cast(s32)y, cast(s32)w, cast(s32)total_height, DARKBROWN);

	panel_layout_add_title(*layout, "myPanel");


	if gui_button(10, "Doom", .{layout.at_x,layout.at_y,layout.width,layout.row_height}) then print("Doom triggered!\n");
	panel_layout_advance_row(*layout);
	
	if gui_button(12, "Boop", .{layout.at_x,layout.at_y,layout.width,layout.row_height}) then print("Boop triggered!\n");
	panel_layout_advance_row(*layout);

}


