extends Sprite2D

const default_texture: Texture2D = preload("res://menu/Default.svg")
const hover_texture: Texture2D = preload("res://menu/Hover.svg")

func _on_area_2d_input_event(_viewport:Node, event:InputEvent, _shape_idx:int) -> void:
    if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
        Audio.play_sfx(Audio.SFX.CLICK)
        get_tree().change_scene_to_file("res://level_data/0.tscn")

func _on_area_2d_mouse_exited() -> void:
    texture = default_texture
func _on_area_2d_mouse_entered() -> void:
    texture = hover_texture
