extends Area2D

signal more()

func _input(event):
	if event.is_action_pressed("dive"):
		if overlaps_body($"/root/Global".player):
			emit_signal("more")
			
