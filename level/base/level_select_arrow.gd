extends Node2D

signal pressed

func _on_area_2d_input_event(_viewport:Node, event:InputEvent, _shape_idx:int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		pressed.emit()

const default_texture = preload("res://addons/Prinbles_GUI_Asset_Silent (1.0.0)/asset/svg/Buttons/Square-Medium/ArrowRight/Default.svg")
const hover_texture = preload("res://addons/Prinbles_GUI_Asset_Silent (1.0.0)/asset/svg/Buttons/Square-Medium/ArrowRight/Hover.svg")
func _on_area_2d_mouse_exited() -> void:
	$Sprite2D.texture = default_texture

func _on_area_2d_mouse_entered() -> void:
	$Sprite2D.texture = hover_texture
