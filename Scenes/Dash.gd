extends Node2D

onready var durationTimer = $timer

func dash_start(duration):
	durationTimer.wait_time = duration
	durationTimer.start()

func is_dashing():
	return !durationTimer.is_stopped()

