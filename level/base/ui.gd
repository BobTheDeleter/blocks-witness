extends Node2D

func position_ui() -> void:
	global_position = %camera.screen_to_world_px(global_position)
