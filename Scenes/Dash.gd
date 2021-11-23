extends Node2D

onready var durationTimer = $timer
var collision = false

signal dash_stopped()
signal upDash_stopped()
signal downDash_stopped()

func dash_start(duration):
	collision = false
	durationTimer.wait_time = duration
	durationTimer.start()
	get_parent().set_collision_layer(524288)
	get_parent().set_collision_mask(524288)
	yield($timer, "timeout")
	if collision == false:
		emit_signal("dash_stopped")
	yield(get_tree().create_timer(0.15), "timeout")
	get_parent().set_collision_layer(1)
	get_parent().set_collision_mask(1)

func upDash_start(duration):
	collision = false
	durationTimer.wait_time = duration
	durationTimer.start()
	get_parent().set_collision_layer(524288)
	get_parent().set_collision_mask(524288)
	yield($timer, "timeout")
	if collision == false:
		emit_signal("upDash_stopped")
	yield(get_tree().create_timer(0.15), "timeout")
	get_parent().set_collision_layer(1)
	get_parent().set_collision_mask(1)
	
func downDash_start(duration):
	collision = false
	durationTimer.wait_time = duration
	durationTimer.start()
	get_parent().set_collision_layer(524288)
	get_parent().set_collision_mask(524288)
	yield($timer, "timeout")
	if collision == false:
		emit_signal("downDash_stopped")
	yield(get_tree().create_timer(0.15), "timeout")
	get_parent().set_collision_layer(1)
	get_parent().set_collision_mask(1)
	
func is_dashing():
	return !durationTimer.is_stopped()
	
