extends Control

func _ready():
	$Score.text = str($"/root/Global".points)
	$Score2.text = str($"/root/Global".previous_points)
