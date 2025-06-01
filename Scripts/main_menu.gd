extends Control


func _ready() -> void:
	$StartButton.grab_focus()

func _on_start_button_pressed() -> void:
	Signals.emit_signal("game_started")
	get_tree().change_scene_to_file("res://Scenes/map_01.tscn")
	

func _on_clear_save_button_pressed() -> void:
	$ClearSavePanel.visible = true
	$ClearSavePanel/Back.grab_focus()

func _on_back_pressed() -> void:
	$ClearSavePanel.visible = false
	$ClearSavePanel/ClearedSavePanel.visible = false
	$StartButton.grab_focus()
	
func _on_clear_save_pressed() -> void:
	SaveSystem.clear_save()
	$ClearSavePanel/ClearedSavePanel.visible = true
	$ClearSavePanel/ClearedSavePanel/Back.grab_focus()
	
