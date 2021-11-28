extends Button

export(String, FILE) var next_scene: = ""

func _on_button_up():
	$UseSfx.play()
	yield(get_tree().create_timer(0.2), "timeout")
	$"/root/Transition".transition(next_scene)
