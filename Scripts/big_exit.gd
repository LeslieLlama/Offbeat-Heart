extends Area2D

func _ready() -> void:
	$Credits.visible = false
	$Credits2.visible = false
	$Credits3.visible = false
	$Credits4.visible = false
	$ExitButton.visible = false

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.is_frozen = true
		body.visible = false
		await get_tree().create_timer(2).timeout
		$Credits.visible = true
		await get_tree().create_timer(2).timeout
		$Credits2.text = str(
			"Keepsakes : ",SaveSystem.number_of_powerups,"/3\n",
			"Stamps: ",SaveSystem.number_of_moons,"/20"
		)
		$Credits2.visible = true
		await get_tree().create_timer(2).timeout
		$Credits3.visible = true
		await get_tree().create_timer(2).timeout
		$Credits4.visible = true
		await get_tree().create_timer(4).timeout
		$ExitButton.visible = true
		$ExitButton.grab_focus()
		


func _on_exit_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")
