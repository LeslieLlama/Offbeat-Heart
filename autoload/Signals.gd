extends Node

#signal update_ui(rabbits : int, lives : int)

signal collectible_obtained(itemName)
signal savepoint_activated(savepoint_position)

signal new_room_entered(area2d : Area2D, roomname : String)
signal room_exited(area2d : Area2D, roomname : String)

signal game_started()
signal game_loaded()

signal TurnEnd()

signal new_dialouge(dialouge : String)
signal end_dialouge()

signal player_jump()
