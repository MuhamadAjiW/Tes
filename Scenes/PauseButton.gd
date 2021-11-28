extends Button

export(String, FILE) var next_scene: = ""

signal cache_stop()

func _ready():
	self.connect("cache_stop", $"/root/Global", "_resetcache")

func _on_Button3_button_up():
	$UseSfx.play()
	get_tree().paused = false
	$"/root/Transition".transition(next_scene)
	emit_signal("cache_stop")
