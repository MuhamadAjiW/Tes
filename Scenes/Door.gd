extends Area2D

export(String, FILE) var next_scene: = ""

func _input(event):
	if event.is_action_pressed("dive"):
		if get_overlapping_bodies().size() > 0:
			get_tree().change_scene(next_scene)
	
