class_name GameCamera
extends Camera2D

func get_mouse_position_world_px() -> Vector2:
	return get_viewport().get_mouse_position() - Vector2(DisplayServer.window_get_size()) / 2 + %board.size_px / 2

func screen_to_world_px(screen_pos: Vector2) -> Vector2:
	return screen_pos + global_position - Vector2(DisplayServer.window_get_size() / 2)

func world_to_screen_px(world_pos: Vector2) -> Vector2:
	return world_pos - global_position + Vector2(DisplayServer.window_get_size() / 2)
