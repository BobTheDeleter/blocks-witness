class_name Level
extends TileMapLayer

@export var data: LevelData

# Get the last part of the file name to determine the next level
@onready var next = str(int(get_scene_file_path().split("_")[-1].split(".")[0]) + 1)

func _on_valid_solution():
	$solution_text.win()
	await $solution_text.win_text_over
	get_tree().change_scene_to_file("res://level/level_"+next+".tscn")
func _on_invalid_solution():
	$solution_text.lose()

func _ready() -> void:
	initialise_camera()
	position_ui()
	initialise_board()
	generate_elements()
	generate_pieces()

const board_packed_scene = preload("res://level/base/board.tscn")
func initialise_board() -> void:
	var board: Board = board_packed_scene.instantiate()
	board.size_grid = data.board_size
	board.cell_size_px = data.cell_size_px
	add_child(board)
	board.initialise()

const covered_packed_scene = preload("res://element/covered.tscn")
const not_covered_packed_scene = preload("res://element/not_covered.tscn")
const partition_dot_packed_scene = preload("res://element/partition_dot.tscn")
const space_amount_packed_scene = preload("res://element/space_amount.tscn")
func generate_elements() -> void:
	for x in data.board_size.x:
		for y in data.board_size.y:
			var cell = get_cell_tile_data(Vector2i(x, y))
			if cell != null:
				var element: Element
				match cell.get_custom_data("type"):
					0:
						element = covered_packed_scene.instantiate()
					1:
						element = not_covered_packed_scene.instantiate()
					2:
						element = partition_dot_packed_scene.instantiate()
						element.original_colour = cell.get_custom_data("colour")
					3:
						element = space_amount_packed_scene.instantiate()
						element.number = cell.get_custom_data("number")

				element.position_grid = Vector2i(x, y)
				add_child(element)

const camera_packed_scene = preload("res://level/base/camera.tscn")
func initialise_camera() -> void:
	var camera: GameCamera = camera_packed_scene.instantiate()
	camera.global_position = data.board_size * data.cell_size_px
	add_child(camera)

const solution_text_packed_scene = preload("res://level/base/solution_text.tscn")
func position_ui() -> void:
	var text = solution_text_packed_scene.instantiate()
	text.global_position = Vector2(data.board_size.x * data.cell_size_px / 2.0, -100)
	add_child(text)

const piece_packed_scene = preload("res://piece/piece.tscn")
func generate_pieces() -> void:
	for piece_data in data.pieces:
		var piece: Piece = piece_packed_scene.instantiate()
		piece.piece_data = piece_data
		add_child(piece)
