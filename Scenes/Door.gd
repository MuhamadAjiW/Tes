extends Area2D

export(String, FILE) var next_scene: = ""

func _input(event):
	if event.is_action_pressed("dive"):
		if overlaps_body($"/root/Global".player) and $"/root/Global".player.stateDead == false:
			$"/root/Transition".transition(next_scene)
			Global.door_name = name
