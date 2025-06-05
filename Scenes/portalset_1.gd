extends Node2D

var warp_offset = 15

func _on_blue_portal_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		$OrangePortal.monitoring = false
		if body.global_position.y > global_position.y:
			body.global_position = Vector2($OrangePortal.global_position.x, $OrangePortal.global_position.y + warp_offset)
		else:
			body.global_position = Vector2($OrangePortal.global_position.x, $OrangePortal.global_position.y - warp_offset)
		body.velocity.y *= -1
		await get_tree().create_timer(0.3).timeout
		$OrangePortal.monitoring = true
			
func _on_orange_portal_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		$BluePortal.monitoring = false
		if body.global_position.y > global_position.y:
			body.global_position = Vector2($BluePortal.global_position.x, $BluePortal.global_position.y + warp_offset)
			
		else:
			body.global_position = Vector2($BluePortal.global_position.x, $BluePortal.global_position.y - warp_offset)
		body.velocity.y *= -1
	await get_tree().create_timer(0.3).timeout
	$BluePortal.monitoring = true
