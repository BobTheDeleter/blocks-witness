extends Node

var highest_completed_level: int
var current_level: int

func load_level(level_num: int) -> void:
	# change the scene to the specified level
	var level_scene = "res://level/" + str(level_num) + ".tscn"
	if not ResourceLoader.exists(level_scene):
		return
	get_tree().change_scene_to_file(level_scene)
