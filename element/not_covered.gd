extends Element

var line_thickness: float
var centre: Vector2
var cell_size_px: float

const type = TYPE.NOT_COVERED

func initialise(board: Board) -> void:
	colour = Colours.ORANGE
	line_thickness = board.line_thickness
	cell_size_px = board.cell_size_px
	centre = Vector2(board.cell_size_px, board.cell_size_px) / 2

func _draw() -> void:
	draw_set_transform(Vector2(cell_size_px / 2, ((0.5)-(sqrt(2)/2.0)) * cell_size_px), PI / 4, Vector2(1, 1))
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
	return data[position_grid]["piece"] == null
