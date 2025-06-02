extends CharacterBody2D

@export var speed = 200
@export var jump_speed = -600
@export var gravity = 3000
@export_range(0.0, 1.0) var friction = 0.1
@export_range(0.0 , 1.0) var acceleration = 0.25

var dir : float = 1

func _ready() -> void:
	Signals.TurnEnd.connect(_turn_end)
	
func _physics_process(delta: float) -> void:
	if $RayCast2D.is_colliding() == true:
		print("aa")
		dir *=- 1
		$RayCast2D.target_position.x *=-1
	
func _turn_end():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position:x", (position.x+(32*dir)), 0.5).set_trans(Tween.TRANS_SINE)
