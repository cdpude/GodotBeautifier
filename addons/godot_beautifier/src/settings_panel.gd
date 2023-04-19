@tool
extends Window

const P_EnableRandomTheme := "beautifier/enable_random_theme"
const P_ThemeScript := "beautifier/theme_script"

enum Key {ENABLE_RANDOM_THEME, SET_THEME, OPEN_GITHUB}

var Main : EditorPlugin
var theme_id := -1

@onready var _EditorSettings : EditorSettings
@onready var _EnableRandomButton := $MarginContainer/VBoxContainer/EnableRandom/HBoxContainer/CheckBox
@onready var _ThemeButton := $MarginContainer/VBoxContainer/SetTheme/HBoxContainer/MenuButton
@onready var _ThemePopup : PopupMenu = _ThemeButton.get_popup()
@onready var _GithubButton := $MarginContainer/VBoxContainer/Github/HBoxContainer/LinkButton
	

func _ready() -> void:
	if Main:
		_EditorSettings = Main.get_editor_interface().get_editor_settings()
	
	close_requested.connect(hide)
	
	if ProjectSettings.has_setting(P_EnableRandomTheme):
		_EnableRandomButton.button_pressed = ProjectSettings.get_setting(P_EnableRandomTheme)
		$MarginContainer/VBoxContainer/SetTheme.visible = !_EnableRandomButton.pressed
	_EnableRandomButton.button_up.connect(_changed.bind(Key.ENABLE_RANDOM_THEME))
	
	if ProjectSettings.has_setting(P_ThemeScript):
		_ThemeButton.text = ProjectSettings.get_setting(P_ThemeScript).get_base_dir().get_file()
	_ThemePopup.about_to_popup.connect(_setup.bind(Key.SET_THEME))
	_ThemePopup.id_pressed.connect(_on_id_pressed.bind(Key.SET_THEME))
	
	_GithubButton.button_up.connect(_changed.bind(Key.OPEN_GITHUB))


func _changed(p_key : int, p_value = null) -> void:
	match p_key:
		Key.ENABLE_RANDOM_THEME:
			ProjectSettings.set_setting(P_EnableRandomTheme, _EnableRandomButton.pressed)
			ProjectSettings.save()
			$MarginContainer/VBoxContainer/SetTheme.visible = !_EnableRandomButton.pressed
		
		Key.SET_THEME:
			var idx := _ThemePopup.get_item_index(p_value)
			var theme_dir : String = _ThemePopup.get_item_metadata(idx)
			var script_path := theme_dir.path_join("theme.gd")
			
			Main.load_theme_script(script_path)
			_ThemeButton.text = str(theme_dir.get_file())
			ProjectSettings.set_setting(P_ThemeScript, script_path)
			ProjectSettings.save()
		
		Key.OPEN_GITHUB:
			OS.shell_open("https://github.com/cdpude/GodotBeautifier")


func _setup(p_key : int) -> void:
	match p_key:
		Key.SET_THEME:
			_ThemePopup.clear()
			for path in get_theme_list():
				add_theme(path)


func _on_id_pressed(p_id : int, p_key : int) -> void:
	_changed(p_key, p_id)


func get_current_dir() -> String:
	var script : Resource = get_script()
	return script.resource_path.get_base_dir()


func get_plugin_root_dir() -> String:
	return get_current_dir().get_base_dir()


func get_dir_list(p_path : String) -> Array:
	var dir := DirAccess.open(p_path)
	var dir_list := []
	
	if dir:
		dir.include_hidden = false
		dir.include_navigational = false
		dir.list_dir_begin()
		
		var dir_name := dir.get_next()
		while dir_name != "":
			if dir.current_is_dir():
				dir_list.append(p_path.path_join(dir_name))
			dir_name = dir.get_next()
	
	return dir_list


func get_theme_list() -> Array:
	var themes_dir := get_plugin_root_dir().path_join("themes")
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
