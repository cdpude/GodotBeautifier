extends BeautifierAPI


func _enter_tree() -> void:
	set_editor_setting("interface/theme/base_color", Color("f7f8fc"))
	set_editor_setting("interface/theme/accent_color", Color("0b244d"))
	set_editor_setting("interface/theme/custom_theme", get_system_file("assets/theme.tres"))
	
	set_text_editor_colors_by_cfg(get_file("assets/Web-Light.tet"))
	
	set_project_setting("rendering/environment/default_clear_color", Color("8f9092"))
