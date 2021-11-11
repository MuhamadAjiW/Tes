extends KinematicBody2D

onready var sprite = $Sprite
onready var coll = $Coll
onready var hitbox = $Area2D/Coll
onready var invulnerabilityTimer = $HitTimer
onready var EffectsPlayer = $EffectsPlayer
onready var health = 3
onready var max_health = 3

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
		if health != 0:
			velocity.y = -100
			if sprite.flip_h == true:
				velocity.x = 300
			elif sprite.flip_h == false:
				velocity.x = -300
			move_and_slide(velocity, Vector2(0,-1), true)
		
func _on_HitTimer_timeout():
	EffectsPlayer.play("Neutral")

func _on_Area2D_Hit():
	takeDamage(1)
	yield(get_tree().create_timer(0.2), "timeout")
	$AI.aware = true
	
func _physics_process(delta):
	if stateDead == false:
		#gravitasi
		if velocity.y < gravitasiMax:
			velocity.y += gravitasi
		elif velocity.y > gravitasiMax:
			velocity.y += (gravitasi/5)
			
		if is_on_floor():
			velocity.x = lerp(velocity.x,0,0.2)
		elif is_on_floor() == false:
			velocity.x = lerp(velocity.x,0,0.08)
		
		velocity = move_and_slide(velocity, Vector2(0,-1), true)
		#hadapan
		if velocity.y == 0 and velocity.x == 0 and not $AI.radar.overlaps_body($"/root/Global".player):
			sprite.play("default")
		elif is_on_floor() and velocity.x != 0:
			if (velocity.x > 250 or velocity.x < -250):
				sprite.play("sprint")
			elif (velocity.x < 250 or velocity.x > -250):
				sprite.play("walk")
		elif is_on_floor() == false:
			if velocity.y < 0:
				sprite.play("jump")
			else:
				sprite.play("fall")
				
		if velocity.x > 0:
			sprite.flip_h = false
			coll.scale.x = 1
			hitbox.scale.x = 1
		elif velocity.x < 0:
			sprite.flip_h = true
			coll.scale.x = -1
			hitbox.scale.x = -1

	elif stateDead == true:
		sprite.play("damage")
		if velocity.y < gravitasiMax:
			velocity.y += gravitasi
		elif velocity.y > gravitasiMax:
			velocity.y += (gravitasi/5)
			
		if is_on_floor():
			velocity.x = lerp(velocity.x,0,0.1)
		elif not is_on_floor():
			velocity.x = lerp(velocity.x,0,0.01)
			
		velocity = move_and_slide(velocity, Vector2(0,-1), true)

func _on_DeathTimer_timeout():
	EffectsPlayer.play("Dead")
	yield(get_tree().create_timer(0.4), "timeout")
	queue_free()
