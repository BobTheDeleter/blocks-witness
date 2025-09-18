class_name LevelBonus
extends Level

func _ready() -> void:
	level_num = int(get_scene_file_path().split(".")[0])
	Progression.current_level = level_num
	Progression.highest_completed_level = max(level_num, Progression.highest_completed_level)

	super._ready()
