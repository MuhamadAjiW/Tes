extends Area2D

signal Hit()

func _process(delta):
	if overlaps_body($"/root/Global".player) and get_parent().invulnerabilityTimer.is_stopped() and get_parent().stateDead == false:
		emit_signal("Hit")
