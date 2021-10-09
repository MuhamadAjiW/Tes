extends CanvasLayer

signal transitioned()

func transition():
	$AnimationPlayer.play("Fade in")
	print("fading")

func _on_AnimationPlayer_animation_finished(anim_name):
	print("done")
	if anim_name == "Fade in":
		emit_signal("transitioned")
		$AnimationPlayer.play("Fade Out")
		print("is detected")
