extends Control

onready var scene_tree: = get_tree()
onready var dead_overlay: = get_node("ColorRect")

var dead: = false setget set_dead

func _on_Player_dead():
	self.dead = not dead

func set_dead(value: bool):
	dead = value
	dead_overlay.visible = value

func _process(delta):
	if dead == true:
		self.visible = true
	else:
		self.visible = false

