extends KinematicBody2D

onready var velocity : Vector2

func _ready():
	pass

func sound():
	if $moveSfx.is_playing() == false:
		$moveSfx.play()

func move(x, y):
	velocity.x = x
	velocity.y = y
	move_and_slide(velocity, Vector2(0,-1), true)
	sound()

func _process(delta):
	pass
