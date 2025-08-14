extends Camera2D

func centre_board(board_size) -> void:
	global_position = board_size / 2
	$"../you_win".position = Vector2(board_size.x / 2, -100)
	%ui.position_ui()

func get_mouse_position_world_px() -> Vector2:
	return get_viewport().get_mouse_position() - Vector2(DisplayServer.window_get_size()) / 2 + %board.size_px / 2

func screen_to_world_px(screen_pos: Vector2) -> Vector2:
	return screen_pos + global_position - Vector2(DisplayServer.window_get_size() / 2)

func world_to_screen_px(world_pos: Vector2) -> Vector2:
	return world_pos - global_position + Vector2(DisplayServer.window_get_size() / 2)
