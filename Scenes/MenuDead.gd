extends Control

onready var scene_tree: = get_tree()
onready var dead_overlay: = get_node("ColorRect")

var dead: = false setget set_dead
signal disable_pause()

func _on_Player_dead():
	self.dead = not dead
	self.visible = true
	$AnimationPlayer.play("New Anim")
	emit_signal("disable_pause")

func set_dead(value: bool):
	dead = value
	dead_overlay.visible = value

func _process(delta):
	pass

