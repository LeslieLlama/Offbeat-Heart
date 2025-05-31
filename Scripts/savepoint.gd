extends Area2D

@export var texture_active : Texture2D
@export var texture_not_active : Texture2D

var is_active = false
var self_position : Vector2
func _ready() -> void:
	Signals.savepoint_activated.connect(other_savepoint_activated)
	self_position = position

func _on_hitbox_body_entered(body: Node2D) -> void:
	Signals.emit_signal("savepoint_activated", self_position)
	if body.is_in_group("player"):
		is_active = true
		$Sprite2D.texture = texture_active
		
func other_savepoint_activated(_self_position):
	is_active = false
	$Sprite2D.texture = texture_not_active
