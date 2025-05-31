extends Node

var moons_collected = 0
var current_save_position : Vector2

func _ready() -> void:
	#load_game()
	pass
	
func set_current_savepoint_pos(new_pos):
	current_save_position = new_pos

func save():
	var save_dict = {
		"current_save_position" : [current_save_position.x, current_save_position.y],
		"moonsCollected" : moons_collected,
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
	
	while save_file.get_position() < save_file.get_length():
		var json_string = save_file.get_line()
		var json = JSON.new()
		var parse_result = json.parse(json_string)
		var node_data = json.get_data()
		
		moons_collected = node_data["moonsCollected"]
		#current_save_position = node_data["current_save_position"]
