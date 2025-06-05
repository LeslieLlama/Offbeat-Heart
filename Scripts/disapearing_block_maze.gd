extends Node2D


var duration : float = 2
func _ready() -> void:
	start_tween()
	
func start_tween():
	var tween = get_tree().create_tween().bind_node(self).set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	tween.set_loops()
	tween.tween_property($Cycle1, "visible", true, duration)
	tween.tween_property($Cycle2, "visible", false, duration)
	tween.chain().tween_property($Cycle1, "visible", false, duration)
	tween.chain().tween_property($Cycle2, "visible", true, duration)
