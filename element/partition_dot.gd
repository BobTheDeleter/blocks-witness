extends Element

var rect: Rect2

const type = TYPE.PARTITION_DOT

var original_colour: Color

func initialise(board: Board) -> void:
	colour = original_colour
	var side_length = board.cell_size_px * 0.5
	var top_left = Vector2(board.cell_size_px, board.cell_size_px) / 2 - Vector2(side_length, side_length) / 2
	rect = Rect2(top_left, Vector2(side_length, side_length))

func _draw() -> void:
	draw_rect(rect, colour)

var is_in_piece: bool = false
var checked_cells: Array = []
func check(data) -> bool:
	is_in_piece = data[position_grid]["piece"] != null
	checked_cells = []
	return check_recursive(data, position_grid)

const orthogonal_offsets = [
	Vector2i(1, 0), Vector2i(-1, 0),
	Vector2i(0, 1), Vector2i(0, -1)
]
func check_recursive(data, cell_grid: Vector2i) -> bool:
	var is_good = true
	for offset in orthogonal_offsets:
		var offset_position = cell_grid + offset
		if not data.has(offset_position):
			continue
		elif offset_position in checked_cells:
			continue
		checked_cells.append(offset_position)
			
		var is_neighbour_in_piece = data[offset_position]["piece"] != null
		if is_neighbour_in_piece != is_in_piece:
			continue # Only check neighbours wihtin the boundary
		
		if data[offset_position]["element"]:
			if data[offset_position]["element"].type == TYPE.PARTITION_DOT:
				if data[offset_position]["element"].colour != colour:
					is_good = is_good and false
					continue
		is_good = is_good and check_recursive(data, offset_position)

	return is_good
