extends Area2D

func _process(delta):
	if overlaps_body($"/root/Global".player) and not $"/root/Global".player.dash.is_dashing():
		$"/root/Global".player.takeDamage(1)
