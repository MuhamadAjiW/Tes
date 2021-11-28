extends Button

onready var call = false

func _on_button_up():
	$UseSfx.play()
	yield(get_tree().create_timer(0.2), "timeout")
	get_tree().quit()
