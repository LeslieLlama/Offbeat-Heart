extends Node

#signal update_ui(rabbits : int, lives : int)

signal collectible_obtained(itemName)
signal savepoint_activated(savepoint_position)

signal new_room_entered(area2d : Area2D, roomname : String)
signal room_exited(area2d : Area2D, roomname : String)

signal game_loaded()
