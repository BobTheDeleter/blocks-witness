class_name LevelBonus
extends Level

func _ready() -> void:
	Progression.current_level = level_num
	Progression.highest_completed_level = max(level_num, Progression.highest_completed_level) # optional skip

	initialise_camera()
	generate_pieces()
	generate_elements()
	initialise_board()
	create_level_select_arrows()
	position_ui()

	clear()