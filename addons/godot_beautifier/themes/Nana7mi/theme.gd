extends BeautifierAPI


func _ready() -> void:
	set_editor_setting("interface/theme/custom_theme", get_system_file("assets/theme.tres"))
	set_editor_setting("interface/editor/code_font", get_system_file("assets/lucida typewriter.ttf"))
	set_editor_setting("interface/theme/base_color", Color("292a2eda"))
	set_editor_setting("interface/theme/accent_color", Color("c8cd3ce3"))
	set_editor_setting("interface/editor/dim_editor_on_dialog_popup", false)
	set_editor_setting("text_editor/script_list/current_script_background_color", Color.TRANSPARENT)
	
	set_text_editor_colors_by_cfg(get_file("assets/Nana7mi.tet"))
	set_text_editor_color("background_color", Color("ffffff00"))
	
	add_background_video(get_editor_panel(), get_file("assets/nana7mi.ogv"))
	
	set_project_setting("rendering/environment/defaults/default_clear_color", Color("28282dff"))
