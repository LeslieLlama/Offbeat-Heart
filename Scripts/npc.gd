extends Node2D


@export var lines = Array([], TYPE_STRING, "", null)
var line_num = 0
var dialouge_sent : bool = false
var starting_pos : Vector2
var tweenA
func _ready() -> void:
	Signals.end_dialouge.connect(_refresh_speech)
	starting_pos = $UpIcon.position
	if tweenA:
		tweenA.kill()
	tweenA = get_tree().create_tween().bind_node(self).set_loops()
	tweenA.tween_property($UpIcon, "position:y", (starting_pos.y-4), 1).set_trans(Tween.TRANS_SINE)
	tweenA.tween_property($UpIcon, "position:y", (starting_pos.y), 1).set_trans(Tween.TRANS_SINE)

func _process(delta: float) -> void:
	if $RayCast2D.is_colliding() or $RayCast2D2.is_colliding():
		$UpIcon.visible = true
		if Input.is_action_just_pressed("up") and dialouge_sent == false:
			Signals.emit_signal("new_dialouge", lines[line_num])
			line_num += 1
			#Loop the dialouge, this is a very simple implementation 
			if line_num >= lines.size():
				line_num = 0
			dialouge_sent = true 
	else:
		$UpIcon.visible = false

func _refresh_speech():
	await get_tree().create_timer(0.01).timeout
	dialouge_sent = false
