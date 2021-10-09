extends Button

export(String, FILE) var next_scene: = ""

func _on_Button3_button_up():
	$"/root/Transition".transition(next_scene)
