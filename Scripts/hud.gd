extends CanvasLayer


func _ready() -> void:
	Signals.collectible_obtained.connect(collectible_aquired)

func collectible_aquired(powerupName):
	$MoonCounter.text = str("Moons : ",SaveSystem.moons_collected,"/20")
		
