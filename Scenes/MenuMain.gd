extends Control

func _ready():
	$Scoreviewer/Score.text = str($"/root/Global".previous_points)
	$"/root/Global".points = 0
	Global.door_name = null
	
	if int(Global.previous_points) == 0:
		$"Start Button2".visible = false
