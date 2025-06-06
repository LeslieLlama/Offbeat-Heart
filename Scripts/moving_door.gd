extends Node2D

var duration = 1
var tween
var at_point_a : bool = false

func _ready() -> void:
	$PointA.visible = false
	$PointB.visible = false
func move_door():
	tween = get_tree().create_tween().bind_node(self).set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	if at_point_a == false:
		tween.tween_property($GateDoor, "position", $PointA.position, duration).set_trans(Tween.TRANS_QUART)
		at_point_a = true
	else:
		tween.tween_property($GateDoor, "position", $PointB.position, duration).set_trans(Tween.TRANS_QUART)
		at_point_a = false


func _on_pressure_plate_1_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		move_door()
	

func _on_pressure_plate_2_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		move_door()
