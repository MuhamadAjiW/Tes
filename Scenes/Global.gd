extends Node

func _ready():
	self.connect("energy_updated", $"/root/Node2D/Player/HUD", "_set_energy")
	self.connect("health_updated", $"/root/Global/Player/HUD", "_set_health")
	
var max_energy = 100
var max_health = 3

signal energy_updated(energy)
signal max_energy_updated(energy)
signal health_updated(health)
signal max_health_updated(health)
signal dead()

onready var energy = max_energy setget _set_energy
onready var health = max_health setget _set_health

#energy
func _set_energy(value):
	var prev_energy = energy
	energy = clamp(value, 0, max_energy)
	if energy != prev_energy:
		emit_signal("energy_updated", energy)

func energyUse(amount):
	_set_energy(energy - amount)

func energyRegen(amount):
	_set_energy(energy + amount)
	
#health
func dead():
	emit_signal("dead")

func _set_health(value):
	var prev_health = health
	health = clamp(value, 0, max_health)
	if health != prev_health:
		emit_signal("health_updated", health)
		if health == 0:
			dead()

func takeDamage(amount):
	_set_health(health - amount)

func takeHealing(amount):
	_set_health(health + amount)
