extends Node2D


func _ready() -> void:
	$LaserGrid_Tilelayer.collision_enabled = false
	$LaserGrid_Tilelayer.visible = false


func _flip_laser():
	$LaserGrid_Tilelayer.collision_enabled = true
	$LaserGrid_Tilelayer.visible = true
	await get_tree().create_timer(2).timeout
	$LaserGrid_Tilelayer.collision_enabled = false
	$LaserGrid_Tilelayer.visible = false
	$Timer.start()
func _on_timer_timeout() -> void:
	_flip_laser()
