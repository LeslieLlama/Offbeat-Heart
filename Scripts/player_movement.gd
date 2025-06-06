extends CharacterBody2D

@export var test_mode = false
var rng = RandomNumberGenerator.new()

@export var speed = 200
@export var jump_speed = -600
@export var base_gravity = 3000
var gravity = 3000
@export_range(0.0, 1.0) var friction = 0.1
@export_range(0.0 , 1.0) var acceleration = 0.25
var cam : Camera2D 

@export var current_jumps = 0
@export var max_jumps = 1
var dive_offset = 30
#var heldItem : Node2D
var facing_dir
var is_dead : bool = false
var is_frozen : bool = false

var tilemap : TileMapLayer
var animated_sprite : AnimatedSprite2D
var is_flipped : bool = false
var can_flip : bool = false
var is_ghost_walking = false

var has_egress_powerup : bool = false
var has_jumpshroom_powerup : bool = false
var has_ghostwalk_powerup : bool = false


var new_area : Area2D
var current_area : Area2D


func _ready() -> void:
	facing_dir = 1
	animated_sprite = $AnimatedSprite2D
	Signals.new_room_entered.connect(_on_new_room_entered)
	Signals.room_exited.connect(_on_room_exited)
	Signals.game_loaded.connect(_game_loaded)
	cam = $Camera2D
	gravity = base_gravity
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("left"):
		#animated_sprite.flip_h = true
		facing_dir = -1
	if Input.is_action_just_pressed("right"):
		#animated_sprite.flip_h = false
		facing_dir = 1
	if Input.is_key_pressed(KEY_R):
		respawn()
		
	#respawn the player if they fall out of bounds somehow
	if position.y > 3000:
		respawn()
	if position.y < -3000:
		respawn()
	if position.x > 4000: 
		respawn()
	if position.x < -4000: 
		respawn()


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
		
	if has_egress_powerup == true and can_flip == true:
		if Input.is_action_just_pressed("down") and (is_on_floor() or is_on_ceiling()):
			flip_dive()
		
	if is_on_floor() || is_on_ceiling():
		current_jumps = 0
	if Input.is_action_just_pressed("action_1"):
		if is_ghost_walking == true:
			return
		if current_jumps < max_jumps:
			velocity.y = jump_speed
			current_jumps += 1
			can_flip = false
			_jump_sound()
			Signals.emit_signal("player_jump")
			
	if Input.is_action_pressed("action_2") and has_ghostwalk_powerup == true:
		if is_on_floor() || is_on_ceiling():
			ghost_walk(true)
	if Input.is_action_just_released("action_2") and has_ghostwalk_powerup == true:
		ghost_walk(false)
		
	
	if dir != 0 and (is_on_floor() or is_on_ceiling() or is_ghost_walking == true):
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
			var is_flippable = data.get_custom_data("Flippable")
			if is_flippable == true:
				can_flip = true
			else: 
				can_flip = false

#func equip(item : Node2D):
	#heldItem = item
	
func flip_dive():
	position.y += dive_offset
	is_flipped = !is_flipped
	jump_speed *= -1
	dive_offset *= -1
	up_direction *= -1
	#animated_sprite.flip_v = !animated_sprite.flip_v
	self.scale.y *= -1
	
	
	#if is_flipped == true:
		#animated_sprite.modulate = Color("000000")
	#else:
		#animated_sprite.modulate = Color("ffffff")
	gravity *= -1
	
func normal_gravity_flip():
	is_flipped = !is_flipped
	jump_speed *= -1
	dive_offset *= -1
	up_direction *= -1
	self.scale.y *= -1
	gravity *= -1
	
func ghost_walk(is_active : bool):
	if is_active == true:
		gravity = 0
		is_ghost_walking = true
		$GhostFloorSprite.visible = true
	else: 
		gravity = base_gravity
		if is_flipped:
			gravity *= -1
		is_ghost_walking = false
		$GhostFloorSprite.visible = false
	
	
func external_death():
	#velocity = Vector2(250*-facing_dir,-250)
	is_dead = true
	animated_sprite.visible = false
	$CPUParticles2D.emitting = true
	$DeathSound.play()
	await get_tree().create_timer(1).timeout
	respawn()
	
func respawn():
	print("respawn!")
	animated_sprite.visible = true
	is_dead = false
	ghost_walk(false)
	velocity = Vector2.ZERO
	position = Vector2(SaveSystem.current_save_position.x, SaveSystem.current_save_position.y)
	if is_flipped == true:
		flip_dive()
	
func _jump_sound():
	var pitchRandomisation = rng.randf_range(1, 1.5)
	$JumpSound.pitch_scale = pitchRandomisation
	$JumpSound.play()

	
func _on_new_room_entered(area: Area2D) -> void:
	new_area = area
	#set camera bounds on inital spawn in
	if current_area == null:
		_set_cam(area)
		
func _on_room_exited(area: Area2D):
	#if new_area == null:
		#return
	if area == new_area:
		return
	_set_cam(area)
	var varb = 0
	position = Vector2(position.x+varb, position.y+varb)
	varb += 20
	current_area = new_area
	#new_area = null
		
func _set_cam(area: Area2D):
	var collision_shape = new_area.get_node("CollisionShape2D")
	var size = collision_shape.shape.extents*2
	
	#for if room is smaller than viewport size
	var view_size = get_viewport_rect().size
	if size.y < view_size.y:
		size.y = view_size.y
		
	if size.x < view_size.x:
		size.x = view_size.x
	
	cam.limit_top = collision_shape.global_position.y - size.y/2
	cam.limit_left = collision_shape.global_position.x - size.x/2
	
	cam.limit_bottom = cam.limit_top + size.y
	cam.limit_right = cam.limit_left + size.x
	

func _game_loaded():
	if SaveSystem.collectibles_gained.has("egress"):
		has_egress_powerup = true
	if SaveSystem.collectibles_gained.has("jumpshroom"):
		has_jumpshroom_powerup = true
		max_jumps = 2
	if SaveSystem.collectibles_gained.has("ghostwalk"):
		has_ghostwalk_powerup = true
	if test_mode == false:
		respawn()

func aquire_powerup(powerup_name):
	if powerup_name == "egress":
		has_egress_powerup = true
	if powerup_name == "jumpshroom":
		has_jumpshroom_powerup = true
		max_jumps = 2
	if powerup_name == "ghostwalk":
		has_ghostwalk_powerup = true
	
