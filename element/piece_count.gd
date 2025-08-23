extends Element

@export_range(1, 3) var number: int

const type = TYPE.PIECE_AMOUNT

var checked_cells: Array = []
var contiguous_pieces: Array = []
func check(data) -> bool:
    checked_cells = []
    contiguous_pieces = []
    find_contiguous_pieces(data, position_grid)
    var _dummy = contiguous_pieces
    return contiguous_pieces.size() == number

const orthogonal_offsets = [
    Vector2i(1, 0), Vector2i(-1, 0),
    Vector2i(0, 1), Vector2i(0, -1)
]
func find_contiguous_pieces(data, cell_grid: Vector2i) -> void:
    if cell_grid in checked_cells:
        return

    checked_cells.append(cell_grid)

    if not data.has(cell_grid):
        return
    
    if data[cell_grid]["piece"] == null:
        return

    if not data[cell_grid]["piece"] in contiguous_pieces:
        contiguous_pieces.append(data[cell_grid]["piece"])

    for offset in orthogonal_offsets:
        var neighbour = cell_grid + offset
        find_contiguous_pieces(data, neighbour)

var cell_size_px: int
func initialise(board_ref: Board) -> void:
    colour = Colours.BLUE
    cell_size_px = board_ref.cell_size_px
    
    triangle_points.clear()
    for point in base_triangle_points:
        # scale the triangle by cell_size_px * 0.2 and position it at th center of the cell
        triangle_points.append(point * (cell_size_px * 0.2) + Vector2(cell_size_px, cell_size_px) / 2)
    
    square_points.clear()
    for point in base_square_points:
        # scale the square by cell_size_px * 0.2 and position it at above (0, 0)
        square_points.append((point+ Vector2(0, -2.75)) * cell_size_px * 0.1)

const angle_step = PI / 1.5
const base_triangle_points = [
    Vector2(0, 1),
    Vector2(-sqrt(3) / 2, -0.5),
    Vector2(sqrt(3) / 2, -0.5)
]
var triangle_points = []
const base_square_points = [
    Vector2(1, 1),
    Vector2(-1, 1),
    Vector2(-1, -1),
    Vector2(1, -1)
]
var square_points = []

func _draw() -> void:
    draw_colored_polygon(triangle_points, colour)
    for i in range(number):
        var rotated_square_points = []
        for point in square_points:
            rotated_square_points.append(point.rotated(angle_step * i) + Vector2(cell_size_px, cell_size_px) / 2)
        draw_colored_polygon(rotated_square_points, colour)