extends Node2D

onready var spawnpoint = $spawnpoint
var scene = load("res://Scenes/Enemy1.tscn")

func _ready():
	pass
	
func _on_Crown_more():
	var enemy = scene.instance()
	enemy.position.x = spawnpoint.position.x
	enemy.position.y = spawnpoint.position.y
	add_child(enemy)
	yield(get_tree().create_timer(0.4), "timeout")
