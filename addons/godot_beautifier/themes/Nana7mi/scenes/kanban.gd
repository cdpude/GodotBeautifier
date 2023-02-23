tool
extends TextureRect

onready var _Timer := $Timer

enum Mode {MODE_SHOW, MODE_HIDE}

var mode : int = Mode.MODE_SHOW


func _ready():
	_Timer.connect("timeout", self, "_on_time_out")


func _on_time_out() -> void:
	var tween := create_tween()
	match mode:
		Mode.MODE_SHOW:
			tween.tween_property(self, "rect_position:y", rect_position.y + rect_size.y, 1)
			tween.set_trans(Tween.TRANS_BACK)
			tween.set_ease(Tween.EASE_IN)
			_Timer.start(randi() % 40 + 10)
		Mode.MODE_HIDE:
			tween.tween_property(self, "rect_position:y", rect_position.y - rect_size.y, 1)
			tween.set_trans(Tween.TRANS_LINEAR)
			tween.set_ease(Tween.EASE_OUT)
			_Timer.start(randi() % 4 + 2)
	mode = !mode
	tween.play()
