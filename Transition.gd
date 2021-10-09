extends CanvasLayer

func transition(path):
	$ColorRect.visible = true
	$AnimationPlayer.play("Fade")
	yield($AnimationPlayer, "animation_finished")
	assert(get_tree().change_scene(path) == OK)
	$AnimationPlayer.play_backwards("Fade")
	yield($AnimationPlayer, "animation_finished")
	$ColorRect.visible = false
