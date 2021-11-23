extends Area2D

onready var parent = get_parent()
onready var player = get_parent().get_node("Player")
onready var wall = get_parent().get_node("Wall Moving")
onready var camera_static = get_parent().get_node("Camera2D")
onready var camera_player = get_parent().get_node("Player/Camera2D")

var passed = false
var counter = 0

func done():
	$"/root/Global".player.cutscene = false
	camera_player.current = false
	camera_static.current = true
	get_parent().get_node("Sprite").queue_free()
	get_parent().get_node("DoorUnder").queue_free()
	get_parent().get_node("TileMap1").queue_free()
	get_parent().get_node("TileMap1 wall").queue_free()
	get_parent().get_node("Wall Moving1").queue_free()
	camera_player.queue_free()
	get_parent().initiate()
	print("Done!")
	queue_free()

func conditionreport():
	yield(get_tree().create_timer(0.5), "timeout")
	print("x", camera_player.global_position.x, "and", camera_static.global_position.x)
	print("y", camera_player.global_position.y, "and", camera_static.global_position.y)

func _process(delta):
	if overlaps_body($"/root/Global".player) and passed == false:
		print("function called")
		passed = true
		$"/root/Global".player.cutscene = true
		yield(get_tree().create_timer(0.5), "timeout")
		for i in range(48):
			camera_player.zoom.x += 0.00625
			camera_player.zoom.y += 0.00625
			yield(get_tree().create_timer(0.01), "timeout")
		
	elif passed and player.is_on_floor():
		if ( camera_player.global_position.x < -91.62 or camera_player.global_position.x > -42.12 ):
			if camera_player.global_position.x < camera_static.global_position.x:
				camera_player.global_position.x += 2.5
			else:
				camera_player.global_position.x -= 2.5
		elif ( camera_player.global_position.x < -66.62 or camera_player.global_position.x > -67.12 ):
			if camera_player.global_position.x < camera_static.global_position.x:
				camera_player.global_position.x += 0.5
			else:
				camera_player.global_position.x -= 0.5
		if (camera_player.global_position.y < 1138.08 or camera_player.global_position.y > 1188.58 ):
			if camera_player.global_position.y < camera_static.global_position.y:
				camera_player.global_position.y += 2.5
			else:
				camera_player.global_position.y -= 2.5
		elif (camera_player.global_position.y < 1163.08 or camera_player.global_position.y > 1163.58 ):
			if camera_player.global_position.y < camera_static.global_position.y:
				camera_player.global_position.y += 0.5
			else:
				camera_player.global_position.y -= 0.5
		else:
			if counter < 160:
				wall.move(-60, 0)
				counter += 1
			else:
				done()
			
