extends Element

@export_range(1, 6) var number: int

var type = TYPE.SPACE_AMOUNT

func check(data) -> bool:
	checked_cells = []
	in_empty_space = data[position_grid]["piece"] == null
	return check_recursive(data, position_grid) - 1 == number

const orthogonal_offsets = [
	Vector2i(1, 0), Vector2i(-1, 0),
	Vector2i(0, 1), Vector2i(0, -1)
]
var checked_cells: Array = []
var in_empty_space: bool = false
func check_recursive(data, cell_grid: Vector2i) -> int:
	var count = 1 # base case, surrounded by uncountable cells, only count itself
	for offset in orthogonal_offsets:
		var neighbour = cell_grid + offset
		if neighbour in checked_cells:
			continue
		checked_cells.append(neighbour)
		if not data.has(neighbour):
			continue
		if (data[neighbour]["piece"] == null) != in_empty_space:
			continue

		count += check_recursive(data, neighbour)

	return count

const unit_hexagon_points = [
	Vector2(1, 0),
	Vector2(0.5, sqrt(3) / 2),
	Vector2(-0.5, sqrt(3) / 2),
	Vector2(-1, 0),
	Vector2(-0.5, -sqrt(3) / 2),
	Vector2(0.5, -sqrt(3) / 2)
]
var hexagon_points = []
const unit_triangle_points = [
	Vector2(0, -1),
	Vector2(-sqrt(3) / 2, 0.5),
	Vector2(sqrt(3) / 2, 0.5)
]
var triangle_points = []
func initialise(board_ref: Board) -> void:
	colour = Colours.BROWN
	board = board_ref
	hexagon_points.clear()
	triangle_points.clear()
	for point in unit_hexagon_points:
		hexagon_points.append(point * (board_ref.cell_size_px * 0.2) + Vector2(board_ref.cell_size_px, board_ref.cell_size_px) / 2)
	for point in unit_triangle_points:
		# scale the triangle to have radius cell_size_px * 0.1 and position it above the hexagon with a gap
		triangle_points.append(point * (board_ref.cell_size_px * 0.1) + Vector2(0, -(0.5 + sqrt(3) / 2) * board_ref.cell_size_px * 0.2))
const angle_step = PI / 3
var board: Board
func _draw() -> void:
	draw_colored_polygon(hexagon_points, colour)
	for i in range(number):
		var rotated_triangle_points = []
		for point in triangle_points:
			rotated_triangle_points.append(point.rotated(angle_step * i) + Vector2(board.cell_size_px, board.cell_size_px) / 2)
		draw_colored_polygon(rotated_triangle_points, colour)
