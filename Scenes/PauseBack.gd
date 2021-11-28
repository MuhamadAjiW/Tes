extends Button

func _on_BackButton_button_up():
	$UseSfx.play()
	get_parent().visible = false
	get_parent().get_parent().pause_main.visible = true
