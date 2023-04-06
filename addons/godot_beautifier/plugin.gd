tool
extends EditorPlugin

const SettingsPanel := preload("src/settings_panel.gd")

var _ThemeScript : EditorPlugin
var _SettingsPanel : SettingsPanel

enum MenuID {SETTINGS, OPEN_DATA_FILE, OPEN_DATA_FOLDER, CLEAR_ALL_CHANGES}


func _enter_tree() -> void:
	## Detect godot data folder. ##
	var dir := Directory.new()
	if !dir.dir_exists(get_editor_data_folder()):
		print("Can't find godot editor data folder.")
		close_plugin()
		return
	## Detect godot data folder. ##
	
	randomize()
	
	## Add tool menu. ##
	var menu := PopupMenu.new()
	menu.add_item("Settings", MenuID.SETTINGS)
	menu.add_item("Open Data File", MenuID.OPEN_DATA_FILE)
	menu.add_item("Open Data Folder", MenuID.OPEN_DATA_FOLDER)
	menu.add_item("Clear All Changes", MenuID.CLEAR_ALL_CHANGES)
	menu.connect("id_pressed", self, "_on_menu_id_pressed")
	add_tool_submenu_item("Beautifier", menu)
	## Add tool menu. ##
	
	## Add settings panel. ##
	_SettingsPanel = preload("src/settings_panel.tscn").instance()
	_SettingsPanel.Main = self
	get_editor_interface().get_base_control().add_child(_SettingsPanel)
	## Add settings panel. ##
	
	## Load theme. ##
	var script_path : String
	if ProjectSettings.has_setting(_SettingsPanel.P_EnableRandomTheme):
		var random : bool = ProjectSettings.get_setting(_SettingsPanel.P_EnableRandomTheme)
		if random:
			script_path = _SettingsPanel.get_random_theme_dir().plus_file("theme.gd")
		elif ProjectSettings.has_setting(_SettingsPanel.P_ThemeScript):
			script_path = ProjectSettings.get_setting(_SettingsPanel.P_ThemeScript)
		else:
			script_path = get_current_dir().plus_file("themes/Night Breeze/theme.gd")
	
	if script_path:
		load_theme_script(script_path)
	## Load theme. ##


func get_editor_data_folder() -> String:
	return OS.get_user_data_dir().get_base_dir().get_base_dir()


func get_global_data_path() -> String:
	return get_editor_data_folder().plus_file("beautifier.cfg")


func get_local_data_path() -> String:
	return ProjectSettings.globalize_path("res://").plus_file("project.godot")


func get_project_dir() -> String:
	return ProjectSettings.globalize_path("res://")


func get_plugin_name() -> String:
	return get_script().resource_path.get_base_dir().get_file()


func get_current_dir() -> String:
	var script : Resource = get_script()
	return script.resource_path.get_base_dir()


func get_file(p_path : String) -> String:
	return get_current_dir().plus_file(p_path)


func _on_menu_id_pressed(p_id : int) -> void:
	match p_id:
		MenuID.SETTINGS:
			_SettingsPanel.popup_centered()
		MenuID.OPEN_DATA_FILE:
			OS.shell_open(get_global_data_path())
		MenuID.OPEN_DATA_FOLDER:
			OS.shell_open(get_global_data_path().get_base_dir())
		MenuID.CLEAR_ALL_CHANGES:
			clear_plugin_changes()


func load_theme_script(p_path : String) -> void:
	clear_theme_script()
	clear_editor_settings()
	clear_project_settings()
	
	var script = load(p_path).new()
	if script is EditorPlugin:
		_ThemeScript = script
		add_child(_ThemeScript)


func clear_theme_script() -> void:
	if is_instance_valid(_ThemeScript):
		_ThemeScript.queue_free()


func clear_editor_settings() -> void:
	var cfg := ConfigFile.new()
	var global_path := get_global_data_path()
	var error := cfg.load(global_path)
	if error == OK:
		var editor_settings : EditorSettings = get_editor_interface().get_editor_settings()
		
		for key in cfg.get_section_keys("editor"):
			var value = cfg.get_value("editor", key)
			editor_settings.set_setting(key, value)
		
		cfg.save(global_path)


func clear_project_settings() -> void:
	var data_path := "beautifier/default_settings"
	if ProjectSettings.has_setting(data_path):
		var set_dict := Dictionary(ProjectSettings.get_setting(data_path))
		for key in set_dict:
			if ProjectSettings.has_setting(key):
				ProjectSettings.set_setting(key, set_dict[key])
		ProjectSettings.clear(data_path)


func clear_global_data() -> void:
	var dir := Directory.new()
	if dir.file_exists(get_global_data_path()):
		dir.remove(get_global_data_path())


func clear_local_data() -> void:
	if ProjectSettings.has_setting("beautifier/theme_script"):
		ProjectSettings.clear("beautifier/theme_script")
	if ProjectSettings.has_setting("beautifier/script_data"):
		ProjectSettings.clear("beautifier/script_data")


func clear_menu() -> void:
	remove_tool_menu_item("Beautifier")
	if is_instance_valid(_SettingsPanel):
		_SettingsPanel.queue_free()


func clear_plugin_changes() -> void:
	clear_editor_settings()
	clear_project_settings()
	clear_global_data()
	clear_local_data()
	close_plugin()


func close_plugin() -> void:
	yield(get_tree(), "idle_frame")
	get_editor_interface().set_plugin_enabled(get_plugin_name(), false)


func _exit_tree():
	clear_menu()
	clear_theme_script()
