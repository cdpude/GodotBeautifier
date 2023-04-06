extends BeautifierAPI


func _enter_tree() -> void:
	set_editor_setting("interface/theme/custom_theme", get_system_file("assets/theme.tres"))
	set_editor_setting("interface/editor/code_font", get_system_file("assets/lucida typewriter.ttf"))
	set_editor_setting("interface/theme/base_color", Color("da292a2e"))
	set_editor_setting("interface/theme/accent_color", Color("e3c8cd3c"))
	set_editor_setting("interface/editor/dim_editor_on_dialog_popup", false)
	set_editor_setting("text_editor/script_list/current_script_background_color", Color.transparent)
	
	set_text_editor_colors_by_cfg(get_file("assets/Nana7mi.tet"))
	set_text_editor_color("background_color", Color("#00ffffff"))
	
	add_background_video(get_editor_panel(), get_file("assets/nana7mi.ogv"))
	
#	add_node(get_editor_panel(), get_file("scenes/kanban.tscn"))
	
	set_project_setting("rendering/environment/default_clear_color", Color("#28282d"))
