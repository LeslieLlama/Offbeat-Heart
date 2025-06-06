extends CanvasLayer

var pause_menu_on : bool = false
var dialouge_panel_on : bool = false

var rooms = []

var not_active_room : Color = Color("545454")
func _ready() -> void:
	Signals.collectible_obtained.connect(collectible_aquired)
	Signals.new_dialouge.connect(_new_dialouge)
	Signals.new_room_entered.connect(_map_update)
	Signals.game_loaded.connect(_game_loaded)
	for i in 30:
		var child_node = ColorRect.new()
		child_node.custom_minimum_size = Vector2(20,20)
		rooms.append(child_node)
		$PausePanel/MapPanel/GridContainer.add_child(child_node)

func collectible_aquired(powerup_name):
	if powerup_name == "egress":
		$PausePanel/EgressPowerupSlot/TextureRect.visible = true
	if powerup_name == "jumpshroom":
		$PausePanel/JumpShroomPowerupSlot/TextureRect.visible = true
	if powerup_name == "ghostwalk":
		$PausePanel/GhostwalkPowerupSlot/TextureRect.visible = true
	$PausePanel/CollectiblesPanel/MoonCounter.text = str(SaveSystem.number_of_moons,"/20")
		
func _process(delta: float) -> void:
	$GlobalTimerMeter.value = 100-($GlobalTimer.time_left * 100)
	if Input.is_action_just_pressed("start"):
		if pause_menu_on == false:
			$PausePanel.visible = true
			pause_menu_on = true
			$PausePanel/BackButton.grab_focus()
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
		$PausePanel/MapPanel/GridContainer.get_child(i).color = not_active_room
	
	#480,300
	var pos : Vector2
	pos.x = _area.global_position.x/480
	pos.y = _area.global_position.y/300
	
	var cell = pos.y * $PausePanel/MapPanel/GridContainer.columns
	cell += pos.x
	$PausePanel/MapPanel/GridContainer.get_child(cell).color = Color("White")
		

func _on_global_timer_timeout() -> void:
	Signals.emit_signal("TurnEnd")
	
func _pause_game(is_pause : bool):
	get_tree().paused = is_pause
	
func _game_loaded():
	if SaveSystem.collectibles_gained.has("egress"):
		$PausePanel/EgressPowerupSlot/TextureRect.visible = true
	if SaveSystem.collectibles_gained.has("jumpshroom"):
		$PausePanel/JumpShroomPowerupSlot/TextureRect.visible = true
	if SaveSystem.collectibles_gained.has("ghostwalk"):
		$PausePanel/GhostwalkPowerupSlot/TextureRect.visible = true
	$PausePanel/CollectiblesPanel/MoonCounter.text = str(SaveSystem.number_of_moons,"/20")
		



func _on_return_to_menu_button_pressed() -> void:
	_pause_game(false)
	get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")
	
	
func _on_back_button_pressed() -> void:
	$PausePanel.visible = false
	pause_menu_on = false
	_pause_game(false)
