extends BeautifierAPI


func _enter_tree() -> void:
	set_editor_setting("interface/theme/icon_and_font_color", 0)
	set_editor_setting("interface/theme/base_color", Color("e1292825"))
	set_editor_setting("interface/theme/accent_color", Color("bfb68a3d"))
	set_editor_setting("interface/theme/custom_theme", get_system_file("assets/theme.tres"))
	set_editor_setting("interface/editor/code_font", get_system_file("assets/SpaceMono-Regular.ttf"))
	set_editor_setting("interface/editor/dim_editor_on_dialog_popup", false)
	set_editor_setting("text_editor/theme/line_spacing", 4)
	set_editor_setting("text_editor/indent/size", 3)
	set_editor_setting("text_editor/script_list/current_script_background_color", Color.transparent)
	
	set_text_editor_colors_by_cfg(get_file("assets/Night-Breeze.tet"))
#	set_text_editor_color("background_color", Color("#f51d1d1d"))
	
#	add_background_music(get_random_file("startup_sounds"), false)
	
	set_project_setting("rendering/environment/default_clear_color", Color("e81d1d1d"))
