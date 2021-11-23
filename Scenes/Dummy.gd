extends KinematicBody2D

onready var sprite = $Sprite
onready var coll = $Coll
onready var hitbox = $Area2D/Coll
onready var invulnerabilityTimer = $HitTimer
onready var EffectsPlayer = $EffectsPlayer
onready var health = 99999
onready var max_health = 99999

signal health_updated(health)
signal max_health_updated(health)

const gravitasi = 25
const gravitasiMax = 400
var stateDead = false
var velocity :Vector2

func _ready():
	pass

func dead():
	stateDead = true
	velocity.y = -500
	$DeathTimer.start()
	if sprite.flip_h == true:
		velocity.x = 500
	elif sprite.flip_h == false:
		velocity.x = -500
	move_and_slide(velocity, Vector2(0,-1), true)
	set_collision_mask(262144)

func _set_health(value):
	var prev_health = health
	health = clamp(value, 0, max_health)
	if health != prev_health:
		if health == 0:
			dead()
			
func takeDamage(amount):
	if invulnerabilityTimer.is_stopped():
		invulnerabilityTimer.start()
		_set_health(health - amount)
		EffectsPlayer.play("Damage")
		EffectsPlayer.queue("Invulnerable")

func _on_HitTimer_timeout():
	EffectsPlayer.play("Neutral")

func _on_Area2D_Hit():
	takeDamage(1)

func _physics_process(delta):
	if stateDead == false:
		#gravitasi
		if velocity.y < gravitasiMax:
			velocity.y += gravitasi
		elif velocity.y > gravitasiMax:
			velocity.y += (gravitasi/5)
