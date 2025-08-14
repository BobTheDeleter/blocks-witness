extends Node

var highest_completed_level: int
var current_level: int

func load_level(level_num: int) -> void:
    # change the scene to the specified level
    var level_scene = "res://level/" + str(level_num) + ".tscn"
    var new_scene = load(level_scene)
    if new_scene:
        get_tree().change_scene_to(new_scene)