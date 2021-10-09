extends Button

onready var call = false

func _on_button_up():
	get_tree().quit()
