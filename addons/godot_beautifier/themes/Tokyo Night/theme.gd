extends BeautifierAPI


func _enter_tree() -> void:
	set_editor_setting("interface/theme/base_color", Color("181822"))
	set_editor_setting("interface/theme/accent_color", Color("6e738e"))
	set_editor_setting("interface/theme/additional_spacing", 4)
	set_editor_setting("interface/theme/border_size", 1)
	set_editor_setting("interface/theme/custom_theme", get_system_file("assets/theme.tres"))
	set_editor_setting("interface/editor/code_font", get_system_file("assets/lucidatypewriterregular.ttf"))
	set_editor_setting("text_editor/script_list/current_script_background_color", Color.transparent)
	
	set_text_editor_colors_by_cfg(get_file("assets/Tokyo-Night.tet"))
	
	set_project_setting("rendering/environment/default_clear_color", Color("1a1b26"))
