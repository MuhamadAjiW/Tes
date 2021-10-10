extends Node2D

onready var durationTimer = $timer

func dash_start(duration):
	durationTimer.wait_time = duration
	durationTimer.start()
	get_parent().collision_layer = 20
	yield($timer, "timeout")
	get_parent().collision_layer = 1

func is_dashing():
	return !durationTimer.is_stopped()
