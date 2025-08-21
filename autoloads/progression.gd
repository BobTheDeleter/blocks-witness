extends Node

var highest_completed_level: int = -1
var current_level: int = -1:
	set(value):
		highest_completed_level = max(value - 1, highest_completed_level)

func _on_change_level(level_num: int) -> void:
	if not does_level_exist(level_num):
		return
	get_tree().change_scene_to_file("res://level/" + str(level_num) + ".tscn")

func does_level_exist(level_num: int) -> bool:
	return ResourceLoader.exists("res://level/" + str(level_num) + ".tscn")