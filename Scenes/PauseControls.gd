extends Button

func _on_PauseControls_button_up():
	get_parent().visible = false
	get_parent().get_parent().pause_controls.visible = true
