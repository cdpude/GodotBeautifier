tool
extends EditorPlugin
class_name BeautifierAPI

enum Anchor {TOP_LEFT, TOP_RIGHT, BOTTOM_LEFT, BOTTOM_RIGHT}

var _EditorSettings : EditorSettings
var _EditorPanel : Panel
var nodes : Array
var custom_preset := false
var custom_colors := false


func _enter_tree() -> void:
	_EditorSettings = get_editor_interface().get_editor_settings()
	_EditorPanel = get_editor_interface().get_base_control()


func get_editor_settings() -> EditorSettings:
	return _EditorSettings


func get_editor_panel() -> Panel:
	return _EditorPanel


func get_editor_setting(p_setting : String):
	return _EditorSettings.get_setting(p_setting)


func get_global_data_path() -> String:
	return OS.get_user_data_dir().get_base_dir().get_base_dir().plus_file("beautifier.cfg")


func get_local_data_path() -> String:
	return ProjectSettings.globalize_path("res://").plus_file("project.godot")


func get_current_dir() -> String:
	var script : Resource = get_script()
	return script.resource_path.get_base_dir()


func get_file(p_path : String) -> String:
	return get_current_dir().plus_file(p_path)


func get_system_file(p_path : String) -> String:
	return ProjectSettings.globalize_path(get_file(p_path))


func get_random_file(p_path : String) -> String:
	var dir := Directory.new()
	var file_list := []
	var path := get_current_dir().plus_file(p_path)
	
	if dir.open(path) == OK:
		dir.list_dir_begin(true, true)
		var file_name := dir.get_next()
		while file_name != "":
			if !dir.current_is_dir() && file_name.get_extension() != "import":
				file_list.append(file_name)
			file_name = dir.get_next()
	
	return path.plus_file(file_list[randi() % file_list.size()])


func get_random_dir(p_path : String) -> String:
	var dir := Directory.new()
	var dir_list := []
	var path := get_current_dir().plus_file(p_path)
	
	if dir.open(path) == OK:
		dir.list_dir_begin(true, true)
		var dir_name := dir.get_next()
		while dir_name != "":
			if dir.current_is_dir():
				dir_list.append(dir_name)
			dir_name = dir.get_next()
	
	return path.plus_file(dir_list[randi() % dir_list.size()])


func send_message(p_text : String, p_title := "Message", p_anchor := 0, p_size := Vector2()) -> void:
	var dialog := WindowDialog.new()
	dialog.window_title = p_title
	
	var label := Label.new()
	label.anchor_right = 1 ; label.anchor_bottom = 1
	label.align = Label.ALIGN_CENTER
	label.valign = Label.VALIGN_CENTER
	label.autowrap = true
	label.clip_text = true
	label.text = p_text
	
	dialog.add_child(label)
	dialog.connect("hide", self, "_on_message_dialog_hide", [dialog])
	get_editor_panel().add_child(dialog)
	
	if p_size == Vector2():
		p_size = Vector2(360, 80)
	
	match p_anchor:
		0:
			dialog.popup_centered(p_size)
		1:
			dialog.popup(Rect2(get_editor_panel().rect_size - p_size - Vector2(10, 10), p_size))


func _on_message_dialog_hide(p_dialog : WindowDialog) -> void:
	p_dialog.queue_free()


func add_node(p_to : Node, p_path : String) -> void:
	var node : Node = load(p_path).instance()
	nodes.append(node)
	p_to.add_child(node)


func add_background_image(p_control : Control, p_path : String, p_stretch_mode := 0) -> void:
	var texture_rect := TextureRect.new()
	nodes.append(texture_rect)
	
	texture_rect.anchor_right = 1
	texture_rect.anchor_bottom = 1
	texture_rect.expand = true
	texture_rect.stretch_mode = p_stretch_mode
	texture_rect.texture = load(p_path)
	
	p_control.add_child(texture_rect)
	p_control.move_child(texture_rect, 0)


func add_background_video(p_control : Control, p_path : String, p_loop := true, p_volumn := 0) -> void:
	var video_player := VideoPlayer.new()
	nodes.append(video_player)
	
	video_player.anchor_bottom = 1
	video_player.anchor_right = 1
	video_player.expand = true
	video_player.stream = load(p_path)
	video_player.volume = p_volumn
	
	if p_loop:
		var error := video_player.connect("finished", self, "_on_video_player_finished", [video_player])
	
	p_control.add_child(video_player)
	p_control.move_child(video_player, 0)
	
	video_player.play()


func _on_video_player_finished(p_video_player : VideoPlayer) -> void:
	p_video_player.play()


func add_background_music(p_path : String,  p_loop := true, p_volumn_db := 0.0) -> void:
	var music_player := AudioStreamPlayer.new()
	
	var music_stream : AudioStream = load(p_path)
	music_player.stream = music_stream
	music_player.volume_db = p_volumn_db
	
	if music_stream is AudioStreamMP3 || music_stream is AudioStreamOGGVorbis:
		music_stream.loop = p_loop
	elif music_stream is AudioStreamSample:
		if p_loop:
			music_stream.set_loop_mode(AudioStreamSample.LOOP_FORWARD)
		else:
			music_stream.set_loop_mode(AudioStreamSample.LOOP_DISABLED)
	
	var error := music_player.connect("finished", self, "_on_music_player_finished", [music_player])
	
	add_child(music_player)
	
	music_player.play()


func _on_music_player_finished(p_music_player : AudioStreamPlayer) -> void:
	nodes.erase(p_music_player)
	p_music_player.queue_free()


func set_editor_setting(p_setting : String, p_value) -> void:
	if !custom_preset && p_setting.begins_with("interface/theme/"):
		_set_editor_setting("interface/theme/preset", "Custom")
		custom_preset = true
	elif !custom_colors && p_setting.begins_with("text_editor/highlighting/"):
		_set_editor_setting("text_editor/theme/color_theme", "Custom")
		custom_colors = true
	_set_editor_setting(p_setting, p_value)


func _set_editor_setting(p_setting : String, p_value) -> void:
	if _EditorSettings.has_setting(p_setting):
		var old_value = get_editor_setting(p_setting)
		var cfg := ConfigFile.new()
		
		cfg.load(get_global_data_path())
		if !cfg.has_section_key("editor", p_setting):
			cfg.set_value("editor", p_setting, old_value)
		cfg.save(get_global_data_path())
		
		if p_value != old_value:
			_EditorSettings.set_setting(p_setting, p_value)


func set_project_setting(p_setting : String, p_value) -> void:
	var data_path := "beautifier/default_settings"
	var set_dict := {}
	
	if ProjectSettings.has_setting(p_setting):
		if ProjectSettings.has_setting(data_path):
			set_dict = ProjectSettings.get_setting(data_path)
	
		var old_value = ProjectSettings.get_setting(p_setting)
		if !set_dict.has(p_setting):
			set_dict[p_setting] = old_value
			ProjectSettings.set_setting(data_path, set_dict)
		
		if p_value != old_value:
			ProjectSettings.set_setting(p_setting, p_value)


func set_text_editor_color(p_name : String, p_color : Color) -> void:
	set_editor_setting("text_editor/highlighting/" + p_name, p_color)


func set_text_editor_colors(p_dict : Dictionary) -> void:
	for key in p_dict:
		if key is String && p_dict[key] is String:
			set_editor_setting("text_editor/highlighting/" + key, Color("#" + p_dict[key]))


func set_text_editor_colors_by_cfg(p_path : String, p_section := "color_theme") -> void:
	var cfg := ConfigFile.new()
	var error := cfg.load(p_path)
	
	if error == OK:
		var dict := {}
		var keys := cfg.get_section_keys(p_section)
		for key in keys:
			dict[key] = cfg.get_value(p_section, key)
		
		set_text_editor_colors(dict)


#func set_theme_font(p_theme : Theme , p_type_name : String, p_dict : Dictionary) -> void:
#	if !p_theme:
#		return
#
#	for key in p_dict:
#		if !(key is String):
#			return
#
#		var font_path : String = p_dict[key]
#		if !(font_path is String):
#			return
#
#		font_path = get_file(font_path)
#		var font : Font = load(font_path)
#		if !font:
#			return
#
#		p_theme.set_font(key, p_type_name, font)


func file_exists(p_path : String) -> bool:
	return File.new().file_exists(p_path)


func dir_exists(p_path : String) -> bool:
	return Directory.new().dir_exists(p_path)


func store_global_data(p_key : String, p_value) -> void:
	var cfg := ConfigFile.new()
	var res = load(get_global_data_path())
	if res is ConfigFile:
		cfg = res
	
	cfg.set_value(get_current_dir(), p_key, p_value)
	cfg.save(get_global_data_path())


func store_local_data(p_key : String, p_value) -> void:
	var data_path := "beautifier/script_data"
	var dict := {}
	var script_dir := get_current_dir()
	var script_dict := {}
	
	if ProjectSettings.has_setting(data_path):
		dict = ProjectSettings.get_setting(data_path)
		script_dict = dict[script_dir]
	
	script_dict[p_key] = p_value
	dict[script_dir] = script_dict
	ProjectSettings.set_setting(data_path, dict)


func get_global_data(p_key : String):
	var cfg := ConfigFile.new()
	var res = load(get_global_data_path())
	if !(res is ConfigFile):
		return
	cfg = res
	
	return cfg.get_value(get_current_dir(), p_key)


func get_local_data(p_key : String):
	var data_path := "beautifier/script_data"
	var script_dir := get_current_dir()
	var dict := {}
	var script_dict := {}
	
	if ProjectSettings.has_setting(data_path):
		dict = ProjectSettings.get_setting(data_path)
		script_dict = dict[script_dir]
	
	return script_dict[p_key]


func clear_cache() -> void:
	for c in nodes:
		if c is Node && is_instance_valid(c):
			c.queue_free()
	nodes.clear()


func _exit_tree():
	clear_cache()
