extends Node2D

var arrowA_starting_pos : Vector2
var arrowB_starting_pos : Vector2

var doorA_active : bool = false
var doorB_active : bool = false

var player
var tweenA
var tweenB
func _ready() -> void:
	$ScoobyDoorA/UpIcon.visible = false
	$ScoobyDoorB/UpIcon.visible = false
	arrowA_starting_pos = $ScoobyDoorA/UpIcon.position
	arrowB_starting_pos = $ScoobyDoorB/UpIcon.position
	if tweenA:
		tweenA.kill()
	tweenA = get_tree().create_tween().bind_node(self).set_loops()
	tweenA.tween_property($ScoobyDoorA/UpIcon, "position:y", (arrowA_starting_pos.y-4), 1).set_trans(Tween.TRANS_SINE)
	tweenA.tween_property($ScoobyDoorA/UpIcon, "position:y", (arrowA_starting_pos.y), 1).set_trans(Tween.TRANS_SINE)
	if tweenB:
		tweenB.kill()
	tweenB = get_tree().create_tween().bind_node(self).set_loops()
	tweenB.tween_property($ScoobyDoorB/UpIcon, "position:y", (arrowB_starting_pos.y-4), 1).set_trans(Tween.TRANS_SINE)
	tweenB.tween_property($ScoobyDoorB/UpIcon, "position:y", (arrowB_starting_pos.y), 1).set_trans(Tween.TRANS_SINE)

func _on_scooby_door_a_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		$ScoobyDoorA/UpIcon.visible = true
		player = body
		doorA_active = true
	
func _on_scooby_door_a_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		$ScoobyDoorA/UpIcon.visible = false
		doorA_active = false
		
func _on_scooby_door_a_2_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		$ScoobyDoorB/UpIcon.visible = true
		player = body
		doorB_active = true

func _on_scooby_door_a_2_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		$ScoobyDoorB/UpIcon.visible = false
		doorB_active = false
		
func _process(delta: float) -> void:
	if doorA_active == true and Input.is_action_just_pressed("up"):
		player.global_position = $ScoobyDoorB.global_position
		doorA_active = false
	if doorB_active == true and Input.is_action_just_pressed("up"):
		player.global_position = $ScoobyDoorA.global_position
		doorB_active = false
