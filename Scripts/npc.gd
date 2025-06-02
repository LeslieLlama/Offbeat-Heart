extends Node2D


@export var lines = Array([], TYPE_STRING, "", null)
var line_num = 0
var dialouge_sent : bool = false

func _ready() -> void:
	Signals.end_dialouge.connect(_refresh_speech)

func _process(delta: float) -> void:
	if $RayCast2D.is_colliding() or $RayCast2D2.is_colliding():
		if Input.is_action_just_pressed("up") and dialouge_sent == false:
			Signals.emit_signal("new_dialouge", lines[line_num])
			line_num += 1
			#Loop the dialouge, this is a very simple implementation 
			if line_num >= lines.size():
				line_num = 0
			dialouge_sent = true 

func _refresh_speech():
	await get_tree().create_timer(0.01).timeout
	dialouge_sent = false
