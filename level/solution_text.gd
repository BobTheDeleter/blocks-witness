extends Label

func _ready() -> void:
	visible = false

func finish() -> void:
	text = "You completed all\nthe levels!"
	visible = true

func win() -> void:
	text = "Level Complete :D"
	visible = true

func lose() -> void:
	text = "Try Again D:"
	visible = true
	await get_tree().create_timer(3).timeout
	visible = false