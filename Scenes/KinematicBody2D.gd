extends KinematicBody2D

export (float) var max_energy = 100
export (float) var max_health = 3

onready var sprite: = $Sprite
onready var dash: = $Dash
onready var HUD: = $HUD
onready var invulnerabilityTimer = $HitTimer
onready var EffectsPlayer = $EffectsPlayer
onready var energy = max_energy setget _set_energy
onready var health = max_health setget _set_health

signal energy_updated(energy)
signal max_energy_updated(energy)
signal health_updated(health)
signal max_health_updated(health)
signal dead()

const gravitasi = 25
const gravitasiMax = 400
const jumpSpeed = 500
const walkSpeed = 150
const sprintSpeed = 400
const dashSpeed = 20000
const dashDuration = 0.2
var velocity :Vector2
var stateAttackStance = false
var stateDead = false
var doubleJump = false
var speed = 0

func _input(event):
	pass

func _ready():
	pass

func _process(delta):
	pass

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
	stateDead = true

func _set_health(value):
	var prev_health = health
	health = clamp(value, 0, max_health)
	if health != prev_health:
		emit_signal("health_updated", health)
		if health == 0:
			dead()

func takeDamage(amount):
	if invulnerabilityTimer.is_stopped():
		invulnerabilityTimer.start()
		_set_health(health - amount)
		EffectsPlayer.play("Damage")
		EffectsPlayer.queue("Invulnerable")
		if sprite.flip_h == true:
			velocity.x = 500
			velocity.y = -500
		elif sprite.flip_h == false:
			velocity.x = -500
			velocity.y = -500

func _on_HitTimer_timeout():
	EffectsPlayer.play("Neutral")

func takeHealing(amount):
	_set_health(health + amount)


#movement
func _physics_process(delta):
	if stateDead == false:
		energyRegen(0.5)
		if velocity.y == 0 and velocity.x == 0 and stateAttackStance == false:
			sprite.play("default")
		
	#gravitasi
		if velocity.y < gravitasiMax:
			velocity.y += gravitasi
		elif velocity.y > gravitasiMax:
			velocity.y += (gravitasi/5)
		
	#kanan kiri
		if velocity.x > 0:
			sprite.flip_h = false
		elif velocity.x < 0:
			sprite.flip_h = true
		
		if is_on_floor():
			speed = lerp(speed,150,0.15)
			doubleJump = false
		if Input.is_action_pressed("sprint") and is_on_floor():
			speed = sprintSpeed
		if Input.is_action_pressed("right"):
			if stateAttackStance == true and is_on_floor():
				sprite.flip_h = false
				velocity.x = 0
			else:
				velocity.x = speed
		elif Input.is_action_pressed("left"):
			if stateAttackStance == true and is_on_floor():
				sprite.flip_h = true
				velocity.x = 0
			else:
				velocity.x = -speed

		else:
			if is_on_floor():
				velocity.x = lerp(velocity.x,0,0.2)
			else:
				velocity.x = lerp(velocity.x,0,0.08)
		
		velocity = move_and_slide(velocity, Vector2(0,-1), true)
			
	#lompat
		if Input.is_action_just_pressed("Jump"):
			if is_on_floor() and stateAttackStance == false:
				velocity.y += -jumpSpeed
			if stateAttackStance == true and energy >=50:
				dash.dash_start(dashDuration)
				if dash.is_dashing():
					velocity.y = -2000
					var delay = 0.08
					yield(get_tree().create_timer(delay), "timeout")
					velocity.y =  -jumpSpeed
					doubleJump = false
					energyUse(50)
				speed = sprintSpeed
			elif stateAttackStance == true and energy <50:
				HUD.insufficient()
			if Input.is_action_just_pressed("Jump") and doubleJump == false and not is_on_floor() and stateAttackStance == false:
				velocity.y =  -jumpSpeed/1.3
				doubleJump = true
		
		if Input.is_action_just_pressed("dive") and not is_on_floor() and stateAttackStance == true and energy >=50:
			dash.dash_start(dashDuration)
			if dash.is_dashing():
				velocity.y += 2000
				var delay = 0.08
				yield(get_tree().create_timer(delay), "timeout")
				velocity.y =  jumpSpeed
				doubleJump = false
				energyUse(50)
		elif Input.is_action_just_pressed("dive") and not is_on_floor() and stateAttackStance == true and energy <50:
			HUD.insufficient()
				
	#animasi
		if is_on_floor() == false and stateAttackStance == false:
			if velocity.y < 0:
				sprite.play("jump")
			else:
				sprite.play("fall")
		if (velocity.x > 200 or velocity.x < -200) and is_on_floor():
			sprite.play("sprint")
		elif (velocity.x < 200 or velocity.x > -200) and velocity.x != 0 and is_on_floor():
			sprite.play("walk")
		
	#attack
		stateAttackStance = false
		if Input.is_action_pressed("attack"):
			stateAttackStance = true
			sprite.play("attack")
			if Input.is_action_just_pressed("sprint") and energy >=50:
				energyUse(50)
				var delay = 0.2
				yield(get_tree().create_timer(delay), "timeout")
				dash.dash_start(dashDuration)
				if dash.is_dashing():
					speed = dashSpeed
					velocity.y = 0
					if sprite.flip_h == false:
						velocity.x = speed
					elif sprite.flip_h == true:
						velocity.x = -speed
					var collision = move_and_collide(velocity*delta)
					if collision:
						velocity.x = 0
						velocity.y = 0
				speed = sprintSpeed
				velocity.y = 0
				if sprite.flip_h == false:
					velocity.x = speed
				elif sprite.flip_h == true:
					velocity.x = -speed
				doubleJump = false
			elif Input.is_action_just_pressed("sprint") and energy <50:
				HUD.insufficient()
		
#damage taking
		if get_slide_count() > 0:
			for i in range(get_slide_count()):
				if "spike" in get_slide_collision(i).collider.name:
					takeDamage(1)
		
	#hitbox
		if sprite.flip_h == true:
			$Coll.scale.x = -1
		elif sprite.flip_h == false:
			$Coll.scale.x = 1

#dying ragdoll
	if stateDead == true:
		sprite.play("damage")
		if velocity.y < gravitasiMax:
			velocity.y += gravitasi
		elif velocity.y > gravitasiMax:
			velocity.y += (gravitasi/5)
		if is_on_floor():
			velocity.x = lerp(velocity.x,0,0.2)
		elif not is_on_floor():
			velocity.x = lerp(velocity.x,0,0.08)
		velocity = move_and_slide(velocity, Vector2(0,-1), true)
		

