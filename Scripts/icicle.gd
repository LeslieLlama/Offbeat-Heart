extends Area2D

var spawn_pos : Vector2
var speed = 150

func _ready() -> void:
	position = spawn_pos

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.external_death()


func _process(delta: float) -> void:
	position.y += speed * delta

func _on_timer_timeout() -> void:
	self.queue_free()
