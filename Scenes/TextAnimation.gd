extends Node2D

export(String, FILE) var next_scene: = ""

var ongoing = true
var done = false
var counter = 0

func _input(event):
	if event is InputEventKey:
		if event.pressed:
			$"/root/Transition".transition(next_scene)

func _ready():
	if int(Global.previous_points) != 0:
		next_scene = "res://Scenes/S Area4.tscn"
	
	yield(get_tree().create_timer(1), "timeout")
	$CanvasLayer/ColorRect/Label/AnimationPlayer.play("New Anim")
	yield(get_tree().create_timer(1), "timeout")
	$CanvasLayer/ColorRect/Label2/AnimationPlayer.play("New Anim")
	yield(get_tree().create_timer(1), "timeout")
	$CanvasLayer/ColorRect/Label3/AnimationPlayer.play("New Anim")
	yield(get_tree().create_timer(2), "timeout")
	ongoing = false
	
func start():
	if counter == 1:
		$CanvasLayer/ColorRect/Label/AnimationPlayer.play_backwards("New Anim")
		$CanvasLayer/ColorRect/Label2/AnimationPlayer.play_backwards("New Anim")
		$CanvasLayer/ColorRect/Label3/AnimationPlayer.play_backwards("New Anim")
		$CanvasLayer/ColorRect2/Background/AnimationPlayer.play_backwards("New Anim")
		yield(get_tree().create_timer(1), "timeout")
		$CanvasLayer/ColorRect2/Background2/AnimationPlayer.play("New Anim")
		yield(get_tree().create_timer(1), "timeout")
		$CanvasLayer/ColorRect/Label4/AnimationPlayer.play("New Anim")
		yield(get_tree().create_timer(1), "timeout")
		$CanvasLayer/ColorRect/Label5/AnimationPlayer.play("New Anim")
		yield(get_tree().create_timer(1), "timeout")
		$CanvasLayer/ColorRect/Label6/AnimationPlayer.play("New Anim")
		yield(get_tree().create_timer(2), "timeout")
		ongoing = false

	elif counter == 2:
		$CanvasLayer/ColorRect/Label.queue_free()
		$CanvasLayer/ColorRect/Label2.queue_free()
		$CanvasLayer/ColorRect/Label3.queue_free()
		$CanvasLayer/ColorRect2/Background.queue_free()
		
		$CanvasLayer/ColorRect/Label4/AnimationPlayer.play_backwards("New Anim")
		$CanvasLayer/ColorRect/Label5/AnimationPlayer.play_backwards("New Anim")
		$CanvasLayer/ColorRect/Label6/AnimationPlayer.play_backwards("New Anim")
		$CanvasLayer/ColorRect2/Background2/AnimationPlayer.play_backwards("New Anim")
		yield(get_tree().create_timer(2), "timeout")
		ongoing = false
		
	elif counter == 3:
		$CanvasLayer/ColorRect/Label4.queue_free()
		$CanvasLayer/ColorRect/Label5.queue_free()
		$CanvasLayer/ColorRect/Label6.queue_free()
		
		$CanvasLayer/ColorRect/Label7/AnimationPlayer.play("New Anim")
		yield(get_tree().create_timer(2), "timeout")
		ongoing = false
	
	elif counter == 4:
		$CanvasLayer/ColorRect2/Background2.queue_free()
		
		$CanvasLayer/ColorRect/Label7/AnimationPlayer.play_backwards("New Anim")
		yield(get_tree().create_timer(1), "timeout")
		$CanvasLayer/ColorRect2/Background3/AnimationPlayer.play("New Anim")
		yield(get_tree().create_timer(1), "timeout")
		$CanvasLayer/ColorRect/Label8/AnimationPlayer.play("New Anim")
		yield(get_tree().create_timer(2), "timeout")
		ongoing = false
	
	elif counter == 5:
		$CanvasLayer/ColorRect/Label7.queue_free()
		
		$CanvasLayer/ColorRect/Label8/AnimationPlayer.play_backwards("New Anim")
		yield(get_tree().create_timer(1), "timeout")
		$CanvasLayer/ColorRect2/Background4/AnimationPlayer.play("New Anim")
		yield(get_tree().create_timer(1), "timeout")
		$CanvasLayer/ColorRect/Label9/AnimationPlayer.play("New Anim")
		yield(get_tree().create_timer(2), "timeout")
		ongoing = false
	
	elif counter == 6:
		$CanvasLayer/ColorRect/Label8.queue_free()
		
		$CanvasLayer/ColorRect/Label9/AnimationPlayer.play_backwards("New Anim")
		yield(get_tree().create_timer(1), "timeout")
		$CanvasLayer/ColorRect/Label10/AnimationPlayer.play("New Anim")
		$CanvasLayer/ColorRect2/AnimationPlayer.play("New Anim")
		yield(get_tree().create_timer(2), "timeout")
		ongoing = false
		
	elif counter == 7:
		$CanvasLayer/ColorRect/Label9.queue_free()
		
		$CanvasLayer/ColorRect2/Background3/AnimationPlayer.play_backwards("New Anim")
		$CanvasLayer/ColorRect2/Background4/AnimationPlayer.play_backwards("New Anim")
		$CanvasLayer/ColorRect/Label10/AnimationPlayer.play_backwards("New Anim")
		yield(get_tree().create_timer(2), "timeout")
		$CanvasLayer/ColorRect2/Background5/AnimationPlayer.play("New Anim")
		yield(get_tree().create_timer(2), "timeout")
		$CanvasLayer/ColorRect/Label11/AnimationPlayer.play("New Anim")
		yield(get_tree().create_timer(2), "timeout")
		$CanvasLayer/ColorRect/Label12/AnimationPlayer.play("New Anim")
		yield(get_tree().create_timer(2), "timeout")
		ongoing = false
	
	elif counter == 8:
		$CanvasLayer/ColorRect2/Background3.queue_free()
		$CanvasLayer/ColorRect2/Background4.queue_free()
		$CanvasLayer/ColorRect/Label10.queue_free()
		
		$CanvasLayer/ColorRect2/Background5/AnimationPlayer.play_backwards("New Anim")
		$CanvasLayer/ColorRect/Label11/AnimationPlayer.play_backwards("New Anim")
		$CanvasLayer/ColorRect/Label12/AnimationPlayer.play_backwards("New Anim")
		
		$CanvasLayer/ColorRect2/Background6/AnimationPlayer.play("New Anim")
		yield(get_tree().create_timer(2), "timeout")
		$CanvasLayer/ColorRect/Label13/AnimationPlayer.play("New Anim")
		yield(get_tree().create_timer(2), "timeout")
		ongoing = false
		
	elif counter == 9:
		$CanvasLayer/ColorRect2/Background5.queue_free()
		$CanvasLayer/ColorRect/Label11.queue_free()
		$CanvasLayer/ColorRect/Label12.queue_free()
		
		$CanvasLayer/ColorRect/Label13/AnimationPlayer.play_backwards("New Anim")
		yield(get_tree().create_timer(2), "timeout")
		$CanvasLayer/ColorRect/Label14/AnimationPlayer.play("New Anim")
		yield(get_tree().create_timer(4), "timeout")
		ongoing = false
	
	elif counter == 10:
		$"/root/Transition".transition(next_scene)

func _on_Timer_timeout():
	$CanvasLayer/ColorRect2/Label7.visible == true
	$CanvasLayer/ColorRect2/Label7/AnimationPlayer.play("New Anim")

func _process(delta):
	if ongoing == false:
		counter += 1
		start()
		ongoing = true
		print("counter ", counter)
		yield(get_tree().create_timer(0.5), "timeout")
