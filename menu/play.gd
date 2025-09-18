extends TextureButton

func _on_pressed() -> void:
	if %CheckBox.button_pressed:
		Progression.highest_completed_level = 1000
	Audio.play_sfx(Audio.SFX.CLICK)
	get_tree().change_scene_to_file("res://level_data/0.tscn")
