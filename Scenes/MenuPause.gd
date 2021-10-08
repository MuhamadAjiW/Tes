extends Control

onready var scene_tree: = get_tree()
onready var pause_overlay: = get_node("ColorRect")

var paused: = false setget set_paused

func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		self.paused = not paused
		scene_tree.set_input_as_handled()


func set_paused(value: bool):
	paused = value
	scene_tree.paused = value
	pause_overlay.visible = value

func _on_Player_dead():
	set_process_unhandled_input(false)
	self.visible = false

func _process(delta):
	if paused == true:
		self.visible = true
	else:
		self.visible = false
