extends KinematicBody2D

onready var sprite: = $Sprite

const gravitasi = 25
const gravitasiMax = 400
const jumpSpeed = 500
const walkSpeed = 150
const sprintSpeed = 400
const dashSpeed = 20000
const dashDuration = 0.2
var velocity :Vector2
var stateAttackStance = false
var doubleJump = false
var speed = 0

func _input(event):
	pass

func _ready():
	pass

func _process(delta):
	pass

func _physics_process(delta):
	if velocity.y == 0 and velocity.x == 0 and stateAttackStance == false:
		sprite.play("default")
	
#gravitasi
	if velocity.y < gravitasiMax:
		velocity.y += gravitasi
	elif velocity.y > gravitasiMax:
		velocity.y += (gravitasi/5)
	
#movement
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
		if stateAttackStance == true and $HUD/EnergyBar.value >=150:
			$Dash.dash_start(dashDuration)
			if $Dash.is_dashing():
				velocity.y = -2000
				var delay = 0.08
				yield(get_tree().create_timer(delay), "timeout")
				velocity.y =  -jumpSpeed
				doubleJump = false
				$HUD.onDash()
			speed = sprintSpeed
		if Input.is_action_just_pressed("Jump") and doubleJump == false and not is_on_floor() and stateAttackStance == false:
			velocity.y =  -jumpSpeed/1.3
			doubleJump = true
	
	if Input.is_action_just_pressed("dive") and not is_on_floor() and stateAttackStance == true and $HUD/EnergyBar.value >=150:
		$Dash.dash_start(dashDuration)
		if $Dash.is_dashing():
			velocity.y += 2000
			var delay = 0.08
			yield(get_tree().create_timer(delay), "timeout")
			velocity.y =  jumpSpeed
			doubleJump = false
			$HUD.onDash()
			
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
		if Input.is_action_just_pressed("sprint") and $HUD/EnergyBar.value >=150:
			var delay = 0.2
			yield(get_tree().create_timer(delay), "timeout")
			$Dash.dash_start(dashDuration)
			if $Dash.is_dashing():
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
			$HUD.onDash()
		elif Input.is_action_just_pressed("sprint") and $HUD/EnergyBar.value >=150:
			$HUD
	
#hitbox
	if sprite.flip_h == true:
		$Coll.scale.x = -1
	elif sprite.flip_h == false:
		$Coll.scale.x = 1
