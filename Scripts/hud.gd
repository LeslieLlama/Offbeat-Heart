extends CanvasLayer

var pause_menu_on : bool = false
func _ready() -> void:
	Signals.collectible_obtained.connect(collectible_aquired)

func collectible_aquired(powerupName):
	#$MoonCounter.text = str("Moons : ",SaveSystem.moons_collected,"/20")
	pass
		
func _process(delta: float) -> void:
	$GlobalTimerMeter.value = 100-($GlobalTimer.time_left * 100)
	
	if Input.is_action_just_pressed("start"):
		if pause_menu_on == false:
			$PausePanel.visible = true
			pause_menu_on = true
		else: 
			$PausePanel.visible = false
			pause_menu_on = false
			



func _on_global_timer_timeout() -> void:
	Signals.emit_signal("TurnEnd")
