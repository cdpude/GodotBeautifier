tool
extends WindowDialog

var Main : EditorPlugin
var theme_id := -1
var P_ThemeScript := "beautifier/theme_script"

onready var _EditorSettings : EditorSettings
onready var _ThemeButton := $MarginContainer/VBoxContainer/MenuButton
onready var _ThemePopup : PopupMenu = _ThemeButton.get_popup()
onready var _GithubButton := $MarginContainer/VBoxContainer/Button


func _ready():
	if Main:
		_EditorSettings = Main.get_editor_interface().get_editor_settings()
	
	_ThemePopup.connect("about_to_show", self, "_on_theme_popup_show")
	_ThemePopup.connect("id_pressed", self, "_on_theme_id_pressed")
	_GithubButton.connect("button_up", self, "_on_github_button_up")


func _on_theme_popup_show() -> void:
	setup_theme_menu()


func _on_theme_id_pressed(p_id : int) -> void:
	var idx := _ThemePopup.get_item_index(p_id)
	var theme_dir : String = _ThemePopup.get_item_metadata(idx)
	var script_path := theme_dir.plus_file("theme.gd")
	
	Main.load_theme_script(script_path)
	_ThemeButton.text = str(script_path.get_base_dir().get_file())


func setup_theme_menu() -> void:
	_ThemePopup.clear()
	for path in get_theme_list():
		add_theme(path)


func get_current_dir() -> String:
	var script : Resource = get_script()
	return script.resource_path.get_base_dir()


func get_plugin_root_dir() -> String:
	return get_current_dir().get_base_dir()


func get_dir_list(p_path : String) -> Array:
	var dir := Directory.new()
	var dir_list := []
	
	if dir.open(p_path) == OK:
		dir.list_dir_begin(true, true)
		var dir_name := dir.get_next()
		while dir_name != "":
			if dir.current_is_dir():
				dir_list.append(p_path.plus_file(dir_name))
			dir_name = dir.get_next()
	
	return dir_list


func get_theme_list() -> Array:
	var themes_dir := get_plugin_root_dir().plus_file("themes")
	var list := get_dir_list(themes_dir)
	return list


func get_random_theme_dir() -> String:
	var dir_list := get_theme_list()
	return dir_list[randi() % dir_list.size()]


func add_theme(p_path : String) -> void:
	theme_id += 1
	_ThemePopup.add_item(p_path.get_file(), theme_id)
	var idx := _ThemePopup.get_item_index(theme_id)
	_ThemePopup.set_item_metadata(idx, p_path)


func _on_github_button_up() -> void:
	OS.shell_open("https://github.com/cdpude/GodotBeautifier")
