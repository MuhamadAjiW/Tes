extends KinematicBody2D

var velocity :Vector2
var direction = true

func _physics_process(delta):
	if direction:
		velocity.x = 40
		velocity = move_and_slide(velocity, Vector2(0,-1), true)
		yield(get_tree().create_timer(2), "timeout")
		direction = false
	else:
		velocity.x = -40
		velocity = move_and_slide(velocity, Vector2(0,-1), true)
		yield(get_tree().create_timer(2), "timeout")
		direction = true
