extends Control

func _ready():
	$Scoreviewer/Score.text = str($"/root/Global".previous_points)
