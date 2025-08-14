extends Sprite2D

signal win_text_over

const you_win_image = preload("res://level/base/you_win.png")
const you_suck_image = preload("res://level/base/you_suck.png")

const you_win_time: float = 5
const you_suck_time: float = 3

func _ready() -> void:
    visible = false

func win() -> void:
    texture = you_win_image
    visible = true
    await get_tree().create_timer(you_win_time).timeout
    visible = false
    win_text_over.emit()

func lose() -> void:
    texture = you_suck_image
    visible = true
    await get_tree().create_timer(you_suck_time).timeout
    visible = false