extends Button

export(String, FILE) var next_scene: = ""

signal dead()

func _on_DeadButton_button_up():
	get_tree().change_scene(next_scene)
	emit_signal("dead")
