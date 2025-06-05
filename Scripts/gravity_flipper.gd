extends Area2D

var warp_offset = 15
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if body.global_position.y > global_position.y:
			body.position.y -= warp_offset
		else: 
			body.position.y += warp_offset
		body.normal_gravity_flip()
		body.velocity.y = 0
		
