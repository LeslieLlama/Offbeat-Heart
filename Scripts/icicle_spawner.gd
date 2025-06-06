extends Node2D

@export var Icicle : PackedScene
var rng = RandomNumberGenerator.new()



func _on_timer_timeout() -> void:
	_spawn_iceicle()


func _spawn_iceicle():
	var b = Icicle.instantiate()
	b.spawn_pos = Vector2(rng.randi_range(0,666.0),10)
	add_child(b)
	
	
