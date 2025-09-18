extends TextureButton

func _on_pressed() -> void:
	if %CheckBox.button_pressed:
		Progression.highest_completed_level = 1000
	Audio.play_sfx(Audio.SFX.CLICK)
	Progression.change_level(0)
