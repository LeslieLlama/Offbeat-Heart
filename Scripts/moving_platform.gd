extends Node2D

var target : Vector2

@export var duration : float = 2
func _ready() -> void:
	start_tween()
	$PointA.visible = false
	$PointB.visible = false
	
func start_tween():
	var tween = get_tree().create_tween().set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	tween.set_loops().set_parallel(false)
	tween.tween_property($Platform, "position", $PointA.position, duration / 2).set_trans(Tween.TRANS_QUART)
	tween.tween_property($Platform, "position", $PointB.position, duration / 2).set_trans(Tween.TRANS_QUART)
