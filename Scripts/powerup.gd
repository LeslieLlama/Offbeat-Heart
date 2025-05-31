extends Area2D

@export var is_powerup : bool = false
@export var powerup_name : String

var starting_position : Vector2
func _ready() -> void:
	starting_position = position
	var tween = get_tree().create_tween().set_loops()
	tween.tween_property(self, "position:y", (starting_position.y-4), 1).set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "position:y", (starting_position.y), 1).set_trans(Tween.TRANS_SINE)
	
func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if is_powerup:
			body.aquire_powerup(powerup_name)
		else:
			SaveSystem.moons_collected += 1
		$Sprite2D.modulate = Color("74b6ff54")
		$CollisionShape2D.call_deferred("set_disabled", true)
		Signals.emit_signal("collectible_obtained", powerup_name)
			
