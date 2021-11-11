extends Node2D

onready var parent = get_parent()
onready var radar = $Awareness
onready var radar_timer = $AwarenessTimer
onready var reset = $ResetTimer
onready var leftside = $Left
onready var leftclose = $LeftClose
onready var rightside = $Right
onready var rightclose = $RightClose
onready var wall = $Wall
onready var obstacle = $Obstacle
onready var obstacle_left = $Obstacle/CollisionShape2D2
onready var obstacle_left_high = $Wall/CollisionShape2D4
onready var obstacle_right = $Obstacle/CollisionShape2D3
onready var obstacle_right_high = $Wall/CollisionShape2D5
onready var above = $Up
onready var total = $Total
var speed = 400
var aware = false

func _on_AwarenessTimer_timeout():
	if radar.overlaps_body($"/root/Global".player):
		aware = true
		
func _on_ResetTimer_timeout():
	if not total.overlaps_body($"/root/Global".player):
		aware = false
	
func _ready():
	pass

func _process(delta):
	if parent.stateDead == false:
		if aware == false:
			if radar.overlaps_body($"/root/Global".player):
				parent.sprite.play("aware")
				if leftside.overlaps_body($"/root/Global".player):
					parent.sprite.flip_h = true
					parent.coll.scale.x = -1
					parent.hitbox.scale.x = -1
				elif rightside.overlaps_body($"/root/Global".player):
					parent.sprite.flip_h = false
					parent.coll.scale.x = 1
					parent.hitbox.scale.x = 1
				if radar_timer.is_stopped():
					radar_timer.start()
			elif not radar.overlaps_body($"/root/Global".player):
				radar_timer.wait_time = 1
				radar_timer.stop()
				
		elif aware == true:
			if total.overlaps_body($"/root/Global".player):
				reset.wait_time = 5
				reset.stop()
				
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
				if leftside.overlaps_body($"/root/Global".player):
					if parent.is_on_floor():
						speed = 400
					parent.velocity.x = -speed
				elif leftclose.overlaps_body($"/root/Global".player):
					if parent.is_on_floor():
						speed = 300
					parent.velocity.x = -speed
				elif rightside.overlaps_body($"/root/Global".player):
					if parent.is_on_floor():
						speed = 400
					parent.velocity.x = speed
				elif rightclose.overlaps_body($"/root/Global".player):
					if parent.is_on_floor():
						speed = 300
					parent.velocity.x = speed
				
				else:
					if parent.is_on_floor():
						parent.velocity.x = lerp(parent.velocity.x,0,0.2)
					else:
						parent.velocity.x = lerp(parent.velocity.x,0,0.08)
				
				if above.overlaps_body($"/root/Global".player):
					if parent.is_on_floor():
						parent.velocity.y += -500
				
				elif (obstacle.get_overlapping_bodies().size() > 0 and wall.get_overlapping_bodies().size() == 0 and obstacle.overlaps_body($"/root/Global".player) == false):
					if parent.is_on_floor():
						parent.velocity.y += -500
			
			elif not total.overlaps_body($"/root/Global".player):
				if parent.sprite.flip_h == false:
					if parent.is_on_floor():
						speed = 150
					parent.velocity.x = speed
				elif parent.sprite.flip_h == true:
					if parent.is_on_floor():
						speed = 150
					parent.velocity.x = -speed
				if (obstacle.get_overlapping_bodies().size() > 0 and wall.get_overlapping_bodies().size() == 0):
					if parent.is_on_floor():
						parent.velocity.y += -500
				if reset.is_stopped():
					reset.start()
					
