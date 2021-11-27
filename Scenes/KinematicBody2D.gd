extends KinematicBody2D

onready var sprite: = $Sprite
onready var dash: = $Dash
onready var HUD: = $HUD
onready var invulnerabilityTimer = $HitTimer
onready var EffectsPlayer = $EffectsPlayer
onready var Pause: = $UI/Pause
onready var energy = $"/root/Global".cached_energy setget _set_energy
onready var health = $"/root/Global".cached_health setget _set_health
onready var max_energy = $"/root/Global".cached_max_energy setget _set_max_health
onready var max_health = $"/root/Global".cached_max_health setget _set_max_energy

signal energy_updated(energy)
signal max_energy_updated(energy)
signal health_updated(health)
signal max_health_updated(health)
signal cache_start()
signal cache_stop()
signal dead()

const gravitasi = 25
const gravitasiMax = 400
const jumpSpeed = 500
const walkSpeed = 150
const sprintSpeed = 400
const dashSpeed = 1250
const dashDuration = 0.1
var velocity :Vector2
var stateAttackStance = false
var stateDead = false
var doubleJump = false
var cutscene = false
var dissapear = false
var speed = 0
var regenSpeed = 0.35

func _ready():
	$"/root/Global".register_player(self)
	self.connect("cache_start", $"/root/Global", "_startcache")
	emit_signal("cache_start")

#energy
func _set_energy(value):
	var prev_energy = energy
	energy = clamp(value, 0, max_energy)
	if energy != prev_energy:
		emit_signal("energy_updated", energy)

func _set_max_energy(value):
	var prev_max_energy = max_energy
	$"/root/Global".max_energy = value
	max_energy = value
	if max_energy != prev_max_energy:
		emit_signal("max_energy_updated", max_energy)

func _set_max_health(value):
	var prev_max_health = max_health
	$"/root/Global".max_health = value
	max_health = value
	if max_health != prev_max_health:
		emit_signal("max_health_updated", max_health)

func energyUse(amount):
	_set_energy(energy - amount)

func energyRegen(amount):
	_set_energy(energy + amount)
	
#health
func dead():
	$DeathTimer.start()
	emit_signal("dead")
	stateDead = true
	set_collision_mask(131072)
	set_collision_layer(131072)

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
		if stateDead == false:
			EffectsPlayer.play("Damage")
			EffectsPlayer.queue("Invulnerable")
		if sprite.flip_h == true:
			velocity.x = 500
			velocity.y = -500
		elif sprite.flip_h == false:
			velocity.x = -500
			velocity.y = -500
		set_collision_mask(131072)
		set_collision_layer(131072)

func _on_HitTimer_timeout():
	EffectsPlayer.play("Neutral")
	if stateDead == false:
		set_collision_mask(1)
		set_collision_layer(1)

func takeHealing(amount):
	_set_health(health + amount)

func buff():
	$HUD/ColorRect.visible = true
	for i in range(25):
		energyRegen(max_energy)
		invulnerabilityTimer.start()
		yield(get_tree().create_timer(0.2), "timeout")
	$HUD/ColorRect.visible = false
	
#movement
func _on_Dash_dash_stopped():
	speed = sprintSpeed
	if sprite.flip_h == true:
		velocity.x = -sprintSpeed
	elif sprite.flip_h == false:
		velocity.x = sprintSpeed
func _on_Dash_downDash_stopped():
	speed = sprintSpeed
	velocity.y = sprintSpeed
func _on_Dash_upDash_stopped():
	speed = sprintSpeed
	velocity.y = -sprintSpeed

func _physics_process(delta):
	if stateDead == false and cutscene == false:
		energyRegen(regenSpeed)
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
		
		if is_on_floor() and dash.is_dashing() == false:
			speed = lerp(speed,150,0.15)
			doubleJump = false
			if Input.is_action_pressed("sprint"):
				speed = sprintSpeed
		if Input.is_action_pressed("right") and dash.is_dashing() == false:
			if stateAttackStance == true and is_on_floor():
				sprite.flip_h = false
				velocity.x = 0
			else:
				velocity.x = speed
		elif Input.is_action_pressed("left") and dash.is_dashing() == false:
			if stateAttackStance == true and is_on_floor():
				sprite.flip_h = true
				velocity.x = 0
			else:
				velocity.x = -speed

		elif dash.is_dashing() == false:
			if is_on_floor():
				velocity.x = lerp(velocity.x,0,0.2)
			else:
				velocity.x = lerp(velocity.x,0,0.08)
		
		velocity = move_and_slide(velocity, Vector2(0,-1), true)
			
	#lompat
		if Input.is_action_just_pressed("Jump"):
			if is_on_floor() and stateAttackStance == false:
				velocity.y += -jumpSpeed
			if Input.is_action_just_pressed("Jump") and doubleJump == false and not is_on_floor() and stateAttackStance == false:
				velocity.y =  -jumpSpeed/1.3
				doubleJump = true
				
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
				dash.dash_start(dashDuration)
				if dash.is_dashing():
					sprite.play("blink")
					speed = dashSpeed
					velocity.y = 0
					if sprite.flip_h == false:
						velocity.x = speed
					elif sprite.flip_h == true:
						velocity.x = -speed
				if sprite.flip_h == false:
					velocity.x = speed
				elif sprite.flip_h == true:
					velocity.x = -speed
				doubleJump = false
			elif Input.is_action_just_pressed("sprint") and energy <50:
				HUD.insufficient()
				
			if Input.is_action_just_pressed("Jump") and energy >=50:
				energyUse(50)
				dash.upDash_start(dashDuration)
				if dash.is_dashing():
					sprite.play("blink")
					speed = dashSpeed
					velocity.y = -speed
					var collision = move_and_collide(velocity*delta)
					if collision:
						speed = sprintSpeed
						dash.collision = true
						velocity.x = 0
						velocity.y = 0
				doubleJump = false
			elif Input.is_action_just_pressed("Jump") and energy <50:
				HUD.insufficient()
				
			if Input.is_action_just_pressed("dive") and energy >=50:
				energyUse(50)
				dash.downDash_start(dashDuration)
				if dash.is_dashing():
					sprite.play("blink")
					speed = dashSpeed
					velocity.y = speed
					var collision = move_and_collide(velocity*delta)
					if collision:
						speed = sprintSpeed
						dash.collision = true
						velocity.x = 0
						velocity.y = 0
				doubleJump = false
			elif Input.is_action_just_pressed("dive") and energy <50:
				HUD.insufficient()
		
		if dash.is_dashing():
			var collision = move_and_collide(velocity*delta)
			if collision:
				speed = sprintSpeed
				dash.collision = true
				velocity.x = 0
				velocity.y = 0

#damage taking
		if get_slide_count() > 0:
			for i in range(get_slide_count()):
				if "spike" in get_slide_collision(i).collider.name:
					takeDamage(1)
	
#dying ragdoll
	elif stateDead == true and dissapear == false:
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

#cutscene
	elif cutscene == true:
		if velocity.y == 0 and velocity.x == 0 and stateAttackStance == false:
			sprite.play("default")
		
		if is_on_floor() == false and stateAttackStance == false:
			if velocity.y < 0:
				sprite.play("jump")
			else:
				sprite.play("fall")
		if (velocity.x > 200 or velocity.x < -200) and is_on_floor():
			sprite.play("sprint")
		elif (velocity.x < 200 or velocity.x > -200) and velocity.x != 0 and is_on_floor():
			sprite.play("walk")
		
		energyRegen(regenSpeed)
		
		if velocity.y < gravitasiMax:
			velocity.y += gravitasi
		elif velocity.y > gravitasiMax:
			velocity.y += (gravitasi/5)
		
		if is_on_floor():
			velocity.x = lerp(velocity.x,0,0.2)
		else:
			velocity.x = lerp(velocity.x,0,0.08)
				
		velocity = move_and_slide(velocity, Vector2(0,-1), true)

#despawn
func _on_DeathTimer_timeout():
	if dissapear == false:
		EffectsPlayer.play("Dead")
		yield(get_tree().create_timer(0.4), "timeout")
		dissapear = true
		sprite.queue_free()
		$Coll.disabled = true
