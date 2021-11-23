extends Node

var player
var caching = false

const max_energy_default = 50
const max_health_default = 3

var max_energy = 50
var max_health = 3
var points = 0
var previous_points = 0

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
	if points > int(previous_points):
		save(points)
		previous_points = points
	points = 0
	caching = false
	cached_max_energy = max_energy_default
	cached_energy = max_energy_default
	cached_max_health = max_health_default
	cached_health = max_health_default

func addpoints(x):
	points += x
	print(points)

func save(score):
	var file = File.new()
	file.open("user://save_score.dat", File.WRITE)
	file.store_var(score, false)
	file.close()

func _ready():
	load_file()
	
func load_file():
	var file = File.new()
	if file.file_exists("user://save_score.dat"):
		file.open("user://save_score.dat", File.READ)
		previous_points = file.get_var()
		file.close()
