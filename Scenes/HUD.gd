extends CanvasLayer

onready var energyBar: = $EnergyBar
onready var energyUnder: = $EnergyUnder
onready var updateTween: = $UpdateTween
onready var pulseTween: = $PulseTween
onready var healthBar = $HealthBar
onready var healthUnder = $HealthUnder
onready var healthNumber = $HealthNumber
onready var energy = $"/root/Global".cached_energy
onready var health = $"/root/Global".cached_health

var default_color = Color.white
var pulse_color = Color.red
var under_color = Color("c7262626")
var pulse_under_color = Color("c7aa3b3b")

func _ready():
	energyBar.value = energy
	energyUnder.value = energy
	healthBar.value = health
	healthUnder.value = health
	healthNumber.text = str(health)

func _on_energy_updated(energy):
	energyBar.value = energy
	updateTween.interpolate_property(energyUnder, "value", energyUnder.value, energy, 0.4, Tween.TRANS_SINE, Tween.EASE_OUT_IN)
	updateTween.start()
	
func _on_max_energy_updated(max_energy):
	energyBar.max_value = max_energy
	energyUnder.max_value = max_energy
	
func insufficient():
	pulseTween.interpolate_property(energyBar, "tint_progress", pulse_color, default_color, 0.4, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	pulseTween.interpolate_property(energyUnder, "tint_progress", pulse_under_color, under_color, 0.4, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	pulseTween.start()

func _on_health_updated(health):
	healthBar.value = health
	updateTween.interpolate_property(healthUnder, "value", healthUnder.value, health, 0.4, Tween.TRANS_SINE, Tween.EASE_OUT_IN)
	updateTween.start()
	healthNumber.text = str(health)
