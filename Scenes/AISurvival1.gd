extends Node2D

onready var parent = get_parent()
onready var player = $"/root/Global".player
onready var leftclose = $LeftClose
onready var rightclose = $RightClose
onready var wall = $Wall
onready var obstacle = $Obstacle
onready var obstacle_left = $Obstacle/CollisionShape2D2
onready var obstacle_left_high = $Wall/CollisionShape2D4
onready var obstacle_right = $Obstacle/CollisionShape2D3
onready var obstacle_right_high = $Wall/CollisionShape2D5
onready var above = $Up
onready var left_limit = $Leftlimit
onready var right_limit = $Rightlimit
onready var seek_timer = $SeekTimer
onready var hold_timer = $HoldTimer

var variation = randi()%10+1
var direction = 0
var speed = 400
	
func _ready():
	pass


func _on_HoldTimer_timeout():
	direction = randi()%2+1
	print("seeking ", direction)
	seek_timer.start()

func _process(delta):
	if parent.stateDead == false:
		if parent.sprite.flip_h == false:
			obstacle_left.disabled = true
			obstacle_left_high.disabled = true
			obstacle_right.disabled = false
			obstacle_right_high.disabled = false
		elif parent.sprite.flip_h == true:
			obstacle_left.disabled = false
			obstacle_left_high.disabled = false
			obstacle_right.disabled = true
			obstacle_right_high.disabled = true
		speed = lerp(speed,150,0.15)
		
		if seek_timer.is_stopped():
			if leftclose.overlaps_body(player):
				speed = 300 + (variation*5)
				parent.velocity.x = -speed
			elif rightclose.overlaps_body(player):
				speed = 300 + (variation*5)
				parent.velocity.x = speed
			elif player.global_position < left_limit.global_position and not leftclose.overlaps_body(player):
				speed = 400 + (variation*10)
				parent.velocity.x = -speed
			elif player.global_position > right_limit.global_position and not rightclose.overlaps_body(player):
				speed = 400 + (variation*10)
				parent.velocity.x = speed
			
			else:
				if parent.is_on_floor():
					parent.velocity.x = lerp(parent.velocity.x,0,0.2)
				else:
					parent.velocity.x = lerp(parent.velocity.x,0,0.08)
		
			if parent.velocity.x == 0:
				if hold_timer.is_stopped():
					hold_timer.start()
			elif parent.velocity.x != 0:
				hold_timer.stop()
				hold_timer.wait_time = 1
		
		elif seek_timer.is_stopped() == false:
			if direction == 1:
				speed = 400 + (variation*10)
				parent.velocity.x = -speed
			elif direction == 2:
				speed = 400 + (variation*10)
				parent.velocity.x = speed
			
		if above.overlaps_body(player):
			if parent.is_on_floor():
				parent.velocity.y += -500
		
		elif (obstacle.get_overlapping_bodies().size() > 0 and wall.get_overlapping_bodies().size() == 0 and obstacle.overlaps_body(player) == false):
			if parent.is_on_floor():
				parent.velocity.y += -500
	

