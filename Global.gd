extends Node

var player
var caching = false

const max_energy_default = 100
const max_health_default = 3

var max_energy = 100
var max_health = 3
onready var cached_energy = max_energy
onready var cached_max_energy = max_energy
onready var cached_health = max_health
onready var cached_max_health = max_health

var door_name = null

func register_player(in_player):
	player = in_player

func _process(delta):
	if caching == true:
		cached_energy = self.player.energy
		cached_max_energy = self.player.max_energy
		cached_health = self.player.health
		cached_max_health = self.player.max_health

func _startcache():
	caching = true

func _resetcache():
	caching = false
	cached_max_energy = max_energy_default
	cached_energy = max_energy_default
	cached_max_health = max_health_default
	cached_health = max_health_default

