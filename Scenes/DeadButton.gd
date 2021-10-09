extends Button

export(String, FILE) var next_scene: = ""

signal dead()
signal cache_stop()

func _ready():
	self.connect("cache_stop", $"/root/Global", "_resetcache")

func _on_DeadButton_button_up():
	get_tree().change_scene(next_scene)
	emit_signal("dead")
	emit_signal("cache_stop")
