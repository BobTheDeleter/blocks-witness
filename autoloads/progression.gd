extends Node

var highest_completed_level: int = -1
var current_level: int = -1:
	set(value):
		current_level = value
		highest_completed_level = max(value - 1, highest_completed_level)

func change_level(level_num: int) -> void:
	if level_num + 1 > levels.size() or level_num < 0:
		return
	current_level = level_num
	get_tree().change_scene_to_packed(levels[level_num])

func does_level_exist(level_num: int) -> bool:
	return ResourceLoader.exists("res://level_data/" + str(level_num) + ".tscn")

@onready var levels: Array[PackedScene] = preload("res://level_data/levels.tres").levels
