extends Node


var current_save_position : Vector2 = Vector2(64,216)
var collectibles_gained = []

func _ready() -> void:
	Signals.savepoint_activated.connect(set_current_savepoint_pos)
	Signals.collectible_obtained.connect(_collectible_obtained)
	await get_tree().create_timer(0.01).timeout
	load_game()
	
func _collectible_obtained(collect_name):
	collectibles_gained.append(collect_name)
	
func set_current_savepoint_pos(new_pos):
	current_save_position = new_pos
	print(str("save point activated : ", current_save_position))
	save_game()

func save():
	var save_dict = {
		"current_save_position" : [current_save_position.x, current_save_position.y],
		"thingsCollected" : collectibles_gained,
		"egress_powerup_aquired" : false
	}
	return save_dict
	
func save_game():
	var save_file = FileAccess.open("user://OBH.save", FileAccess.WRITE)
	
	var json_stirng = JSON.stringify(save())
	
	save_file.store_line(json_stirng)

func load_game():
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
	Signals.emit_signal("game_loaded")
