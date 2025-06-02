extends CanvasLayer

var pause_menu_on : bool = false
var dialouge_panel_on : bool = false
func _ready() -> void:
	Signals.collectible_obtained.connect(collectible_aquired)
	Signals.new_dialouge.connect(_new_dialouge)

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
			
	if dialouge_panel_on == true:
		if Input.is_action_just_pressed("up"):
			_close_dialouge()
			Signals.emit_signal("end_dialouge")

func _new_dialouge(_dialouge : String):
	$DialougePanel/Label.text = _dialouge 
	$DialougePanel.visible = true
	dialouge_panel_on = true
func _close_dialouge():
	$DialougePanel.visible = false
	dialouge_panel_on = false

func _on_global_timer_timeout() -> void:
	Signals.emit_signal("TurnEnd")
