extends BeautifierAPI


func _ready() -> void:
	set_editor_setting("interface/theme/icon_and_font_color", 0)
	set_editor_setting("interface/theme/base_color", Color("292825e1"))
	set_editor_setting("interface/theme/accent_color", Color("b68a3dbf"))
	set_editor_setting("interface/theme/custom_theme", get_system_file("assets/theme.tres"))
	set_editor_setting("interface/editor/code_font", get_system_file("assets/SpaceMono-Regular.ttf"))
	set_editor_setting("interface/editor/dim_editor_on_dialog_popup", false)
	set_editor_setting("text_editor/theme/line_spacing", 4)
	set_editor_setting("text_editor/indent/size", 4)
	set_editor_setting("text_editor/indent/draw_tabs", true)
	set_editor_setting("text_editor/script_list/current_script_background_color", Color.TRANSPARENT)
	
	set_text_editor_colors_by_cfg(get_file("assets/Cool-Black.tet"))
	
	set_project_setting("rendering/environment/defaults/default_clear_color", Color("202020ff"))
