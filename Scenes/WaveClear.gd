extends Node2D

onready var scene_tree: = get_tree()
onready var text_overlay: = $CanvasLayer/ColorRect
onready var player = $"/root/Global".player

signal chosen()

func upgrades():
	get_tree().paused = true
	scene_tree.set_input_as_handled()
	text_overlay.visible = true
	$"/root/Global".player.Pause._on_pause_disable()

func _on_Choice_1_button_up():
	var new_max_health = $"/root/Global".player.max_health + 1
	$"/root/Global".player._set_max_health(new_max_health)
	$"/root/Global".player.takeHealing(1)
	get_tree().paused = false
	text_overlay.visible = false
	$"/root/Global".player.Pause._on_restore_pause()
	emit_signal("chosen")

func _on_Choice_2_button_up():
	var new_regenSpeed= $"/root/Global".player.regenSpeed + 0.1*$"/root/Global".player.regenSpeed
	$"/root/Global".player.regenSpeed = new_regenSpeed
	get_tree().paused = false
	text_overlay.visible = false
	$"/root/Global".player.Pause._on_restore_pause()
	emit_signal("chosen")

func _on_Choice_3_button_up():
	var new_max_energy = $"/root/Global".player.max_energy + 20
	$"/root/Global".player._set_max_energy(new_max_energy)
	$"/root/Global".player.energyRegen(20)
	get_tree().paused = false
	text_overlay.visible = false
	$"/root/Global".player.Pause._on_restore_pause()
	emit_signal("chosen")
	
func _on_Choice_4_button_up():
	$"/root/Global".player.takeHealing($"/root/Global".player.max_health)
	get_tree().paused = false
	text_overlay.visible = false
	$"/root/Global".player.Pause._on_restore_pause()
	emit_signal("chosen")
