extends Area2D

export(String, FILE) var next_scene: = ""

signal cache_stop()

func _ready():
	self.connect("cache_stop", $"/root/Global", "_resetcache")

func _input(event):
	if event.is_action_pressed("dive"):
		if get_overlapping_bodies().size() > 1:
			emit_signal("cache_stop")
			$"/root/Transition".transition(next_scene)
