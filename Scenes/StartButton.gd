extends Button

export(String, FILE) var next_scene: = ""
var scene = ""

func _on_button_up():
	$UseSfx.play()
	yield(get_tree().create_timer(0.2), "timeout")
	if int(Global.previous_points) == 0:
		scene = "res://Scenes/StoryBits.tscn"
	else:
		scene = next_scene
	$"/root/Transition".transition(scene)
