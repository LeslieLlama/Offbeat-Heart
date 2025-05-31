extends CharacterBody2D

@export var speed = 1200
@export var jump_speed = -1800
@export var gravity = 4000
@export_range(0.0, 1.0) var friction = 0.1
@export_range(0.0 , 1.0) var acceleration = 0.25

@export var knife_prefab : PackedScene 

var current_jumps = 0
var max_jumps = 1
var dive_offset = 30
#var heldItem : Node2D
var facing_dir
var is_dead : bool = false
var is_frozen : bool = false

var tilemap : TileMapLayer
var animated_sprite : AnimatedSprite2D
var is_flipped : bool = false

var has_egress_powerup : bool = false

func _ready() -> void:
	facing_dir = 1
	animated_sprite = $AnimatedSprite2D

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("left"):
		#animated_sprite.flip_h = true
		facing_dir = -1
	if Input.is_action_just_pressed("right"):
		#animated_sprite.flip_h = false
		facing_dir = 1
		


func _physics_process(delta):
	velocity.y += gravity * delta
	move_and_slide()
	
	if is_dead == true:
		return
	if is_frozen == true:
		return;
	
	var dir = Input.get_axis("left", "right")
	if dir != 0:
		velocity.x = lerp(velocity.x, dir * speed, acceleration)
	else:
		velocity.x = lerp(velocity.x, 0.0, friction)
		
	if has_egress_powerup == true:
		if Input.is_action_just_pressed("down") and (is_on_floor() or is_on_ceiling()):
			flip_dive()
		
	
	if Input.is_action_just_pressed("action_1"):
		if current_jumps < max_jumps:
			velocity.y = jump_speed
			current_jumps += 1
	#if Input.is_action_just_released("down") and is_on_floor():
		#get_parent().new_rabbit(position)
		
	if is_on_floor() || is_on_ceiling():
		current_jumps = 0
	elif dir != 0 and is_on_floor():
		animated_sprite.play("walk")
	#elif is_on_floor() == false and current_jumps >= 1:
		#animated_sprite.play("double_jump")
	elif is_on_floor() == false:
		animated_sprite.play("jump")
	else: 
		animated_sprite.play("default")
	
	#spike detection
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		if collision.get_collider() is TileMapLayer:
			var data : TileData = collision.get_collider().get_cell_tile_data(collision.get_collider().get_coords_for_body_rid(collision.get_collider_rid()))
			if data == null: 
				return
			var is_spike = data.get_custom_data("Damage")
			if is_spike == true and is_dead == false:
				external_death()

#func equip(item : Node2D):
	#heldItem = item
	
func flip_dive():
	is_flipped = !is_flipped
	position.y += dive_offset
	gravity *= -1
	jump_speed *= -1
	dive_offset *= -1
	animated_sprite.flip_v = !animated_sprite.flip_v
	#if is_flipped == true:
		#animated_sprite.modulate = Color("000000")
	#else:
		#animated_sprite.modulate = Color("ffffff")
	
func external_death():
	velocity = Vector2(500*-facing_dir,-500)
	is_dead = true
	animated_sprite.play("death")
	collision_layer = 0b00000000_00000000_00000000_00000000
	collision_mask = 0b00000000_00000000_00000000_00000000
	
func aquire_powerup(powerup_name):
	if powerup_name == "egress":
		has_egress_powerup = true
	
