extends Node

var starting_position : Vector2 = Vector2(150,455) 
var current_save_position : Vector2 = Vector2(150,455) 
var collectibles_gained = []
var number_of_moons = 0
var number_of_powerups = 0
func _ready() -> void:
	Signals.savepoint_activated.connect(set_current_savepoint_pos)
	Signals.collectible_obtained.connect(_collectible_obtained)
	Signals.game_started.connect(_game_started)
	
func _game_started():
	await get_tree().create_timer(0.01).timeout
	load_game()
	
func _collectible_obtained(collect_name):
	collectibles_gained.append(collect_name)
	if "moon" in collect_name:
		number_of_moons += 1
func set_current_savepoint_pos(new_pos):
	current_save_position = new_pos
	print(str("save point activated : ", current_save_position))
	save_game()

func clear_save():
	current_save_position = starting_position
	collectibles_gained.clear()
	save_game()

func save():
	var save_dict = {
		"current_save_position" : [current_save_position.x, current_save_position.y],
		"thingsCollected" : collectibles_gained,
		"numberOfMoons" : number_of_moons,
		"numberOfPowerups" : number_of_powerups
	}
	return save_dict
	
func save_game():
	var save_file = FileAccess.open("user://OBH.save", FileAccess.WRITE)
	
	var json_stirng = JSON.stringify(save())
	
	save_file.store_line(json_stirng)

func load_game():
	number_of_moons = 0
	if not FileAccess.file_exists("user://OBH.save"):
		return
	var save_file = FileAccess.open("user://OBH.save", FileAccess.READ)
	var node_data
	while save_file.get_position() < save_file.get_length():
		var json_string = save_file.get_line()
		var json = JSON.new()
		var parse_result = json.parse(json_string)
		node_data = json.get_data()
		
	collectibles_gained = node_data["thingsCollected"]
	current_save_position = Vector2(node_data["current_save_position"][0],node_data["current_save_position"][1])
	for i in collectibles_gained:
		if "moon" in i:
			number_of_moons += 1
		else:
			number_of_powerups += 1
	Signals.emit_signal("game_loaded")
	
