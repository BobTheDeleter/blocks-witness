class_name LevelBonus
extends Level

func _ready() -> void:
	Progression.highest_completed_level = max(level_num, Progression.highest_completed_level) # optional skip
	super._ready()
