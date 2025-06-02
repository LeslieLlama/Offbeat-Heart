extends CanvasLayer

var pause_menu_on : bool = false
var dialouge_panel_on : bool = false

var rooms = []
func _ready() -> void:
	Signals.collectible_obtained.connect(collectible_aquired)
	Signals.new_dialouge.connect(_new_dialouge)
	Signals.new_room_entered.connect(_map_update)
	for i in 16:
		var child_node = ColorRect.new()
		child_node.custom_minimum_size = Vector2(10,10)
		rooms.append(child_node)
		$PausePanel/MapPanel/GridContainer.add_child(child_node)

func collectible_aquired(powerupName):
	#$MoonCounter.text = str("Moons : ",SaveSystem.moons_collected,"/20")
	pass
		
func _process(delta: float) -> void:
	$GlobalTimerMeter.value = 100-($GlobalTimer.time_left * 100)
	if Input.is_action_just_pressed("start"):
		if pause_menu_on == false:
			$PausePanel.visible = true
			pause_menu_on = true
			_pause_game(true)
		else: 
			$PausePanel.visible = false
			pause_menu_on = false
			_pause_game(false)
			
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

func _map_update(_area: Area2D):
	for i in rooms.size():
		$PausePanel/MapPanel/GridContainer.get_child(i).color = Color("White")
	
	#480,300
	var pos : Vector2
	pos.x = _area.position.x/480
	pos.y = _area.position.y/300
	
	var cell = pos.y * $PausePanel/MapPanel/GridContainer.columns
	cell += pos.x
	$PausePanel/MapPanel/GridContainer.get_child(cell).color = Color("Red")
		

func _on_global_timer_timeout() -> void:
	Signals.emit_signal("TurnEnd")
	
func _pause_game(is_pause : bool):
	get_tree().paused = is_pause
