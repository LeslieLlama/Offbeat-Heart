extends CharacterBody2D

@export var dir : Vector2
var speed = 120
var has_bounced = false

var colors = [Color(1.0, 0.0, 0.0),
		  Color(0.0, 1.0, 0.0),
		  Color(0.0, 0.0, 1.0),
		  Color(1.0, 1.0, 0.0),
		  Color(0.0, 1.0, 1.0),
		  Color(1.0, 0.0, 1.0)]

func _ready():
	randomize()
	$Sprite2D.modulate = colors[randi() % colors.size()]

func _process(delta: float) -> void:
	move_and_slide()
	
	if (is_on_ceiling() or is_on_floor()) and has_bounced == false :
		dir.y *= -1
		has_bounced = true
		$Sprite2D.modulate = colors[randi() % colors.size()]
		$Timer.start()
	if is_on_wall() and has_bounced == false:
		dir.x *= -1
		has_bounced = true
		$Sprite2D.modulate = colors[randi() % colors.size()]
		$Timer.start()
		
	velocity = dir * speed



func _on_timer_timeout() -> void:
	has_bounced = false


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.external_death()
