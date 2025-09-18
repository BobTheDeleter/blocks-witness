extends Element

var line_thickness: float
var centre: Vector2
var cell_size_px: float

const type = TYPE.COVERED

func initialise(board: Board) -> void:
	colour = Colours.PINK
	line_thickness = board.line_thickness
	cell_size_px = board.cell_size_px
	centre = Vector2(board.cell_size_px, board.cell_size_px) / 2

func _draw() -> void:
	# draw a verticle rectangle in PINK
	draw_rect(Rect2(
		Vector2(cell_size_px / 2 - cell_size_px / 8, cell_size_px / 8),
		Vector2(cell_size_px / 4, cell_size_px * 3 / 4)
	),
		colour
	)
	# draw a horizontal rectangle in PINK
	draw_rect(Rect2(
		Vector2(cell_size_px / 8, cell_size_px / 2 - cell_size_px / 8),
		Vector2(cell_size_px * 3 / 4, cell_size_px / 4)
	),
		colour
	)

func check(data) -> bool:
	return data[position_grid]["piece"] != null
