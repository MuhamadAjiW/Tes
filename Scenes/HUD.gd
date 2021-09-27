extends CanvasLayer

var sufficient = true

export (Color) var pulse_color = Color.red

func onDash():
	$EnergyBar.value -= 150
func insufficient():
	sufficient = false

func lackEnergy():
	$EnergyBar_assign_color

func _ready():
	$EnergyBar.value = 300
	
func _assign_color():
	if sufficient == false:
		$PulseTween.interpolate_property($EnergyBar)
		

func _process(delta):
	$EnergyBar.value += 0.5
