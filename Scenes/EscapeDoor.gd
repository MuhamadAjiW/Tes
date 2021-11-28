extends Area2D

export(String, FILE) var next_scene: = ""

signal cache_stop()

onready var text_overlay: = $CanvasLayer/ColorRect
onready var text_overlay2: = $CanvasLayer/ColorRect2
onready var scene_tree: = get_tree()

var condition = false

func _ready():
	self.connect("cache_stop", $"/root/Global", "_resetcache")

func _input(event):
	if overlaps_body($"/root/Global".player) and $"/root/Global".player.stateDead == false:
		if get_parent().get_parent().wave > 4:
			if event.is_action_pressed("dive"):
				if condition == true:
					get_tree().paused = false
					text_overlay.visible = false
					condition = false
					$moveSfx.play()
					yield(get_tree().create_timer(0.4), "timeout")
					emit_signal("cache_stop")
					
					if Global.points > int(Global.previous_points):
						Global.save(Global.points)
						Global.previous_points = Global.points
					
					$"/root/Transition".transition(next_scene)
						
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
		
		else:
			if event.is_action_pressed("dive"):
				if condition == true:
					get_tree().paused = false
					text_overlay2.visible = false
					condition = false
					yield(get_tree().create_timer(0.1), "timeout")
					$"/root/Global".player.Pause._on_restore_pause()
						
				elif get_tree().paused == false:
					condition = true
					get_tree().paused = true
					scene_tree.set_input_as_handled()
					text_overlay2.visible = true
					$"/root/Global".player.Pause._on_pause_disable()
						
				
			if event.is_action_pressed("pause") and condition == true:
				get_tree().paused = false
				text_overlay2.visible = false
				condition = false
				yield(get_tree().create_timer(0.1), "timeout")
				$"/root/Global".player.Pause._on_restore_pause()
