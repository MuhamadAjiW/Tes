extends Area2D

onready var scene_tree: = get_tree()
onready var text_overlay: = $CanvasLayer/ColorRect
var scene = load("res://Scenes/PowerupBoxUsed.tscn")
var usedbox = scene.instance()

var condition = false

func _input(event):
	if visible == true:
		if overlaps_body($"/root/Global".player):
			if event.is_action_pressed("dive"):
				if condition == true:
					get_tree().paused = false
					text_overlay.visible = false
					condition = false
					$"/root/Global".player.Pause._on_restore_pause()
					$"/root/Global".player.buff()
					$UseSfx.play()
					yield(get_tree().create_timer(0.4), "timeout")
					usedbox.position = self.position
					get_parent().add_child(usedbox)
					get_parent().move_child(usedbox, 1)
					queue_free()
					
				elif get_tree().paused == false:
					condition = true
					get_tree().paused = true
					scene_tree.set_input_as_handled()
					text_overlay.visible = true
					$"/root/Global".player.Pause._on_pause_disable()
					
			
			if event.is_action_pressed("pause") and condition == true:
				get_tree().paused = false
				text_overlay.visible = false
				condition = false
				yield(get_tree().create_timer(0.1), "timeout")
				$"/root/Global".player.Pause._on_restore_pause()
