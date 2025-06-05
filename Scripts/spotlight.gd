extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if body.velocity.x != 0:
			body.external_death()
			$Sprite2D.modulate = Color("FFFFFF")
			await get_tree().create_timer(0.2).timeout
			$Sprite2D.modulate = Color("74b6ff54")
		
