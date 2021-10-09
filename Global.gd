extends Node

var player
var caching = false
var max_energy = 100
var max_health = 3
onready var cached_energy = max_energy
onready var cached_health = max_health

var door_name = null

func register_player(in_player):
	player = in_player

func _process(delta):
	if caching == true:
		cached_energy = self.player.energy
		cached_health = self.player.health

func _startcache():
	caching = true

func _resetcache():
	caching = false
	cached_energy = max_energy
	cached_health = max_health
