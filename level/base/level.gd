extends Node2D

# Get the last part of the file name to determine the next level
@onready var next = str(int(get_scene_file_path().split("_")[-1].split(".")[0]) + 1)

func _on_valid_solution():
	# This function is called when a valid solution is found
	$you_win.texture = preload("res://ui/you-win-cool.png")
	$you_win.visible = true
	await get_tree().create_timer(3).timeout
	get_tree().change_scene_to_file("res://level/level_"+next+".tscn")

const you_suck_texture = preload("res://ui/you_suck.png")
const you_win_texture = preload("res://ui/you-win-cool.png")
func _on_invalid_solution():
	$you_win.texture = you_suck_texture
	$you_win.visible = true
	await get_tree().create_timer(3).timeout
	$you_win.visible = false
	$you_win.texture = you_win_texture

func _ready() -> void:
	$editor.generate_elements()
