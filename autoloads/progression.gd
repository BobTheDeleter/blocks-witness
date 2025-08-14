extends Node

var highest_completed_level: int = -1
var current_level: int = -1

func _on_change_level(level_num: int) -> void:
	# Handle the change level signal
	if not ResourceLoader.exists("res://level/" + str(level_num) + ".tscn"):
		return
	get_tree().change_scene_to_file("res://level/" + str(level_num) + ".tscn")