extends Node2D

onready var spawnpoint1 = $"Spawnpoints/Spawnpoint Botleft"
onready var spawnpoint2 = $"Spawnpoints/Spawnpoint Botright"
onready var spawnpoint3 = $"Spawnpoints/Spawnpoint Topleft"
onready var spawnpoint4 = $"Spawnpoints/Spawnpoint Topright"
onready var spawnpoint5 = $"Spawnpoints/Spawnpoint Top"
var scene = load("res://Scenes/EnemySurvival1.tscn")
var scene2 = load("res://Scenes/EnemyBoss.tscn")
var powerup_scene = load("res://Scenes/PowerupBox.tscn")

var start = false
var spawning = false
var chosen = true
var spawn_roll = 0
var powerup_roll = 0
var wave = 1
var enemycount = 3

func _ready():
	if Global.door_name:
		var door_node = find_node(Global.door_name)
		if door_node:
			$Player.global_position = door_node.global_position

func initiate():
	print("initiating...")
	start = true
	spawning = true
	$CanvasLayer/EffectsPlayer.play("New Anim")

func round_reset():
	$WaveClear/CanvasLayer/ColorRect/Wave.text = str(wave - 1)
	$WaveClear.upgrades()
	print("next enemy: ",enemycount)
	spawning = true

func _on_WaveClear_chosen():
	chosen = true
	
	if wave == 6:
		$Interactive/EscapeDoor/Sprite.visible = false
		$Interactive/EscapeDoor/Sprite2.visible = true
		$Interactive/EscapeDoor/UnlockedSfx.play()
	
	powerup_roll = randi()%10+1
	if powerup_roll == 10:
		var power_up = powerup_scene.instance()
		power_up.position = get_node("Interactive").get_child(0).position
		get_node("Interactive").get_child(0).queue_free()
		get_node("Interactive").add_child(power_up)
		get_node("Interactive").move_child(power_up, 0)

func spawn(x):
	spawning = false
	print("spawning ", x, " enemies")
	for i in range(x):
		print("spawning ", i+1)
		spawn_roll = randi()%4+1
		var enemy = scene.instance()
		if spawn_roll == 1:
			enemy.position.x = spawnpoint1.position.x
			enemy.position.y = spawnpoint1.position.y
		elif spawn_roll == 2:
			enemy.position.x = spawnpoint2.position.x
			enemy.position.y = spawnpoint2.position.y
		elif spawn_roll == 3:
			enemy.position.x = spawnpoint3.position.x
			enemy.position.y = spawnpoint3.position.y
		elif spawn_roll == 4:
			enemy.position.x = spawnpoint4.position.x
			enemy.position.y = spawnpoint4.position.y
		add_child(enemy)
		move_child(enemy, 2)
		yield(get_tree().create_timer(0.5), "timeout")
	print("spawning ", x/10, " Toughnuts")
	for i in range(x/10):
		print("spawning ", i+1)
		var enemy2 = scene2.instance()
		enemy2.position.x = spawnpoint5.position.x
		enemy2.position.y = spawnpoint5.position.y
		add_child(enemy2)
		move_child(enemy2, 2)
		yield(get_tree().create_timer(0.5), "timeout")

func _process(delta):
	$"CanvasLayer/ColorRect/Point counter".text = str($"/root/Global".points)
	if start == true:
		if spawning == true and chosen == true:
			spawn(enemycount)
			chosen = false
		if get_child_count() == 9:
			print("wave done!")
			wave += 1
			enemycount = 1 + wave*2
			round_reset()

