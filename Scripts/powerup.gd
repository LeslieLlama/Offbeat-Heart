extends Area2D

@export var is_powerup : bool = false
@export var powerup_name : String
@export var hint_text : String

var starting_position : Vector2
func _ready() -> void:
	Signals.game_loaded.connect(_game_loaded)
	starting_position = position
	var tween = get_tree().create_tween().bind_node(self).set_loops()
	tween.tween_property(self, "position:y", (starting_position.y-4), 1).set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "position:y", (starting_position.y), 1).set_trans(Tween.TRANS_SINE)
	$HintText.visible = false
	$HintText.text = hint_text
	$CPUParticles2D.texture = $Sprite2D.texture
	
func _game_loaded():
	if SaveSystem.collectibles_gained.has(powerup_name) == true:
		_enable_powerup(false)
	else:
		print(powerup_name)
	
func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if is_powerup:
			body.aquire_powerup(powerup_name)
			$HintText.visible = true
		#SaveSystem.moons_collected += 1
		_enable_powerup(false)
		Signals.emit_signal("collectible_obtained", powerup_name)
		$CPUParticles2D.emitting = true
		$AudioStreamPlayer.play()
		
			
func _enable_powerup(turn_on : bool):
	if turn_on == true:
		$Sprite2D.modulate = Color("FFFFFF")
		$CollisionShape2D.call_deferred("set_disabled", false)
	else:
		$Sprite2D.modulate = Color("74b6ff54")
		$CollisionShape2D.call_deferred("set_disabled", true)
