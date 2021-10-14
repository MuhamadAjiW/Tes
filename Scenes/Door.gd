extends Area2D

export(String, FILE) var next_scene: = ""

func _input(event):
	if event.is_action_pressed("dive"):
		if get_overlapping_bodies().size() > 1 and $"/root/Global".player.stateDead == false:
			$"/root/Transition".transition(next_scene)
			Global.door_name = name
