
// This gui system is based on casey's articles on semantic compression
// ref: https://caseymuratori.com/blog_0015 - 22

// todo: maybe I should strip the raylib part out and have it 
// in a gui_impl.jai - so I don't need raylib for this to work and it can be a generic piece of code



GUI_INVALID_ID :: 666;
GuiState :: struct {
	hot : u32;
	active : u32;
	BACKGROUND_COLOR :: DARKGRAY;
	CONTROL_COLOR :: LIGHTGRAY;
	HOT_COLOR :: GRAY;
	ACTIVE_COLOR :: BLACK;
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

Panel :: struct {
	x      : float;
	y      : float;
	width  : float;	
	height : float;	
	title  : string;
}

PanelLayout :: struct {
	width : float;
	row_height : float;
	total_height : float;
	at_x : float;
	at_y : float;
	ypad : s32 = 5;

	DEF_ROW_HEIGHT :: 30;
	TITLE_HEIGHT :: 40;
}


panel_layout_make :: (p : *Panel) ->PanelLayout {
	return PanelLayout.{
		width = p.width,
		row_height = PanelLayout.DEF_ROW_HEIGHT,
		at_x = p.x,
		at_y = p.y,
		ypad = 5
	};
}
panel_layout_advance_row :: (using layout : *PanelLayout) {
	at_y += row_height;
}
panel_layout_add_title :: (using layout : *PanelLayout, title : string) {
	DrawText(title.data, cast(s32)at_x, cast(s32)at_y, TITLE_HEIGHT, RAYWHITE);
	at_y += TITLE_HEIGHT;
}
panel_layout_complete :: (using layout : *PanelLayout, panel : *Panel) {
	panel.height = layout.at_y - panel.y;	
}
panel_layout_push_button :: (using layout : *PanelLayout, id : u32, text : string) -> bool {
	return gui_button(id, text, .{at_x,at_y,width,row_height});
}


gui_test_panel :: (panel : *Panel) {
	layout := panel_layout_make(panel);

	DrawRectangle(cast(s32)panel.x, cast(s32)panel.y, cast(s32)panel.width, cast(s32)panel.height, gui_state.BACKGROUND_COLOR);
	panel_layout_add_title(*layout, panel.title);


	if panel_layout_push_button (*layout, 10, "Doom") {
		print("Doom Triggered!");
	}
	panel_layout_advance_row(*layout);
	if panel_layout_push_button (*layout, 11, "Noom") {
		print("Noom Triggered!");
	}
	panel_layout_advance_row(*layout);
	if panel_layout_push_button (*layout, 12, "Boom") {
		print("Boom Triggered!");
	}
	panel_layout_advance_row(*layout);
	if panel_layout_push_button (*layout, 13, "Zoom") {
		print("Zoom Triggered!");
	}
	panel_layout_advance_row(*layout);



	// will calc final height (of panel)
	panel_layout_complete(*layout, panel);

}


