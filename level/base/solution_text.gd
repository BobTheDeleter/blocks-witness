extends TextureRect

const you_win_image = preload("res://level/base/you_win.png")
const you_suck_image = preload("res://level/base/you_suck.png")
const finished_image = preload("res://level/base/finish.png")

const you_win_time: float = 3
const you_suck_time: float = 2

func _ready() -> void:
	visible = false

func win() -> void:
	texture = you_win_image
	visible = true

func lose() -> void:
	texture = you_suck_image
	visible = true
	await get_tree().create_timer(you_suck_time).timeout
	visible = false

func finish() -> void:
	texture = finished_image
	visible = true
