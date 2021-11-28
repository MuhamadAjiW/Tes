extends Button

export(String, FILE) var next_scene: = ""

signal dead()
signal cache_stop()

func _ready():
	self.connect("cache_stop", $"/root/Global", "_resetcache")

func _on_DeadButton_button_up():
	emit_signal("dead")
	emit_signal("cache_stop")
	$UseSfx.play()
	yield(get_tree().create_timer(0.4), "timeout")
	$"/root/Transition".transition(next_scene)

