extends KinematicBody2D

onready var velocity : Vector2

func _ready():
	pass

func move(x, y):
	velocity.x = x
	velocity.y = y
	move_and_slide(velocity, Vector2(0,-1), true)

func _process(delta):
	pass
