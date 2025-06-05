extends Node2D

var switch_on : bool = false
func _ready() -> void:
	Signals.player_jump.connect(_switch_blocks)
	
func _switch_blocks():
	if switch_on == true:
		$BlueTiles.collision_enabled = false
		$RedTiles.collision_enabled = true
		$RedTiles.modulate = Color("923964")
		$BlueTiles.modulate = Color("00afb032")
	else:
		$BlueTiles.collision_enabled = true
		$RedTiles.collision_enabled = false
		$RedTiles.modulate = Color("9239644e")
		$BlueTiles.modulate = Color("00afb0")
		
	switch_on = !switch_on
	
