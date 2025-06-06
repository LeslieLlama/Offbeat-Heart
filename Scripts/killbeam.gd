extends Node2D


func _process(delta: float) -> void:
	rotation_degrees += (34 * delta);

func _on_laser_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.external_death()
		$Laser/Sprite2D.modulate = Color("FFFFFF")
		await get_tree().create_timer(0.2).timeout
		$Laser/Sprite2D.modulate = Color("ff3372")
