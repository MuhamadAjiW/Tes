extends Area2D

export(String, FILE) var next_scene: = ""

func _input(event):
	if event.is_action_pressed("dive"):
		if get_overlapping_bodies().size() > 1:
			$"/root/Transition".transition(next_scene)
	
