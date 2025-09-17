class_name Level
extends TileMapLayer

@export var data: LevelData

# Get the file name to determine the level
var level_num:int

func _on_valid_solution():
	Progression.highest_completed_level = max(level_num, Progression.highest_completed_level)
	if Progression.does_level_exist(level_num + 1):
		$ui/popup.win()
		create_next_level_button()
	else:
		$ui/popup.finish()
	Audio.play_sfx(Audio.SFX.WIN)
func _on_invalid_solution():
	$ui/popup.lose()
	Audio.play_sfx(Audio.SFX.LOSE)

func _ready() -> void:
	level_num = int(get_scene_file_path().split(".")[0])
	Progression.current_level = level_num
	initialise_camera()
	generate_pieces()
	generate_elements()
	initialise_board()
	create_ui()
	setup_level_buttons()
	create_level_number()

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
const piece_count_packed_scene = preload("res://element/piece_count.tscn")
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
					4:
						element = piece_count_packed_scene.instantiate()
						element.number = cell.get_custom_data("number")

				element.position_grid = Vector2i(x, y)
				add_child(element)

const camera_packed_scene = preload("res://level/base/camera.tscn")
var camera
func initialise_camera() -> void:
	camera = camera_packed_scene.instantiate()
	add_child(camera)
	camera.global_position = data.board_size * data.cell_size_px / 2

const piece_packed_scene = preload("res://piece/piece.tscn")
func generate_pieces() -> void:
	for piece_data in data.pieces:
		var piece: Piece = piece_packed_scene.instantiate()
		piece.initial_data = piece_data
		piece.cell_size_px = data.cell_size_px
		piece.line_thickness = data.line_thickness
		add_child(piece)
		piece.queue_redraw()

const ui_packed_scene = preload("res://ui/ui.tscn")
const popup_packed_scene = preload("res://level/base/popup.tscn")
func create_ui() -> void:
	var ui = ui_packed_scene.instantiate()
	add_child(ui)
	var popup = popup_packed_scene.instantiate()
	ui.add_child(popup)

func setup_level_buttons() -> void:
	$ui/next.connect("pressed", Progression._on_change_level.bind(level_num + 1))
	$ui/prev.connect("pressed", Progression._on_change_level.bind(level_num - 1))

	$ui/next.connect("pressed", Audio.play_sfx.bind(Audio.SFX.CLICK))
	$ui/prev.connect("pressed", Audio.play_sfx.bind(Audio.SFX.CLICK))

	if Progression.highest_completed_level < level_num:
		$ui/next.disabled = true
		$ui/next.visible = false

	if level_num == 0:
		$ui/prev.disabled = true
		$ui/prev.visible = false

func create_next_level_button() -> void:
	$ui/next.disabled = false
	$ui/next.visible = true

func create_level_number() -> void:
	$ui/level_number.text = "Level " + str(level_num)
