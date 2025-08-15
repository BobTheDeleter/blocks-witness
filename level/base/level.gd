class_name Level
extends TileMapLayer

@export var data: LevelData

# Get the last part of the file name to determine the next level
@onready var level_num = int(get_scene_file_path().split(".")[0])

func _on_valid_solution():
	Progression.highest_completed_level = max(level_num, Progression.highest_completed_level)
	if Progression.does_level_exist(level_num + 1):
		$solution_text.win()
		create_next_level_button()
	else:
		$solution_text.finish()
func _on_invalid_solution():
	$solution_text.lose()

func _ready() -> void:
	Progression.current_level = level_num
	initialise_camera()
	generate_pieces()
	generate_elements()
	initialise_board()
	create_level_select_arrows()
	position_ui()

	clear()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("reset_level"):
		Progression._on_change_level(level_num)

const board_packed_scene = preload("res://level/base/board.tscn")
var board: Board
func initialise_board() -> void:
	board = board_packed_scene.instantiate()
	board.size_grid = data.board_size
	board.cell_size_px = data.cell_size_px
	board.line_thickness = data.line_thickness
	add_child(board)
	board.initialise()

const covered_packed_scene = preload("res://element/covered.tscn")
const not_covered_packed_scene = preload("res://element/not_covered.tscn")
const partition_dot_packed_scene = preload("res://element/partition_dot.tscn")
const space_amount_packed_scene = preload("res://element/cell_count.tscn")
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
var camera
func initialise_camera() -> void:
	camera = camera_packed_scene.instantiate()
	add_child(camera)
	camera.global_position = data.board_size * data.cell_size_px / 2

const solution_text_packed_scene = preload("res://level/base/solution_text.tscn")
var solution_text
func position_ui() -> void:
	solution_text = solution_text_packed_scene.instantiate()
	solution_text.global_position = Vector2(data.board_size.x * data.cell_size_px / 2.0, -100)
	add_child(solution_text)

	if get_tree().get_nodes_in_group("ui").size() > 0:
		get_tree().get_nodes_in_group("ui")[0].global_position = camera.screen_to_world_px(Vector2.ZERO)

const piece_packed_scene = preload("res://piece/piece.tscn")
func generate_pieces() -> void:
	for piece_data in data.pieces:
		var piece: Piece = piece_packed_scene.instantiate()
		piece.initial_data = piece_data
		piece.cell_size_px = data.cell_size_px
		piece.line_thickness = data.line_thickness
		add_child(piece)
		piece.queue_redraw()

const level_select_arrow_packed_scene = preload("res://level/base/level_select_arrow.tscn")
func create_level_select_arrows() -> void:
	if level_num > 0:
		var left_arrow = level_select_arrow_packed_scene.instantiate()
		$ui.add_child(left_arrow)
		left_arrow.rotation = PI
		left_arrow.pressed.connect(Progression._on_change_level.bind(level_num - 1))
		left_arrow.position = Vector2(50, DisplayServer.window_get_size().y / 2.0)
	
	if Progression.highest_completed_level >= level_num:
		var right_arrow = level_select_arrow_packed_scene.instantiate()
		$ui.add_child(right_arrow)
		right_arrow.pressed.connect(Progression._on_change_level.bind(level_num + 1))
		right_arrow.position = Vector2(DisplayServer.window_get_size().x - 50, DisplayServer.window_get_size().y / 2.0)

func create_next_level_button() -> void:
	var next_level_button = level_select_arrow_packed_scene.instantiate()
	$ui.add_child(next_level_button)
	next_level_button.pressed.connect(Progression._on_change_level.bind(level_num + 1))
	next_level_button.position = Vector2(DisplayServer.window_get_size().x - 50, DisplayServer.window_get_size().y / 2.0)