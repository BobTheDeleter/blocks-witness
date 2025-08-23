extends Element

var line_thickness: float
var radius: float
var centre: Vector2

const type = TYPE.NOT_COVERED

func initialise(board: Board) -> void:
	colour = Colours.ORANGE
	line_thickness = board.line_thickness
	radius = (board.cell_size_px - line_thickness) / 2 - board.cell_size_px * 0.1
	centre = Vector2(board.cell_size_px, board.cell_size_px) / 2

func _draw() -> void:
	draw_circle(centre, radius, colour)

func check(data) -> bool:
	return data[position_grid]["piece"] == null
