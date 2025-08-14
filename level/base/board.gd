class_name Board
extends Node2D

signal valid_solution
signal invalid_solution

var size_grid: Vector2i
var cell_size_px: int = 80
var line_thickness: float = 2.0

var area2d: Area2D

var size_px: Vector2
var diag_px: float
var rect_px: Rect2

var data = {}

func initialise() -> void:
	pieces = get_tree().get_nodes_in_group("piece")
	elements = get_tree().get_nodes_in_group("element")

	size_px = Vector2(size_grid * cell_size_px)
	diag_px = size_px.length()
	rect_px = Rect2(Vector2.ZERO, size_px)

	# Create Area2D for board bounds
	area2d = Area2D.new()
	add_child(area2d)
	var shape = CollisionShape2D.new()
	shape.shape = RectangleShape2D.new()
	shape.shape.size = size_px
	shape.position = size_px / 2
	area2d.add_child(shape)
	
	# Initialize board data as a dictionary with Vector2i keys and {element, piece} dicts
	data = {}
	for x in size_grid.x:
		for y in size_grid.y:
			data[Vector2i(x, y)] = {"element": null, "piece": null}

	for element: Element in elements:
		data[element.position_grid]["element"] = element
		element.global_position = Vector2(element.position_grid) * cell_size_px
		element.initialise(self)
	
	for piece: Piece in pieces:
		piece.piece_placed.connect(_on_piece_placed)
		piece.piece_picked_up.connect(_on_piece_picked_up)
	place_palette_pieces()

	connect("valid_solution", get_parent()._on_valid_solution)
	connect("invalid_solution", get_parent()._on_invalid_solution)

var pieces = []
var elements = []
func _on_piece_placed(piece: Piece) -> void:
	# Snap the piece's position to the nearest cell
	var snapped_origin_px = piece.global_position
	snapped_origin_px.x = round(snapped_origin_px.x / cell_size_px) * cell_size_px
	snapped_origin_px.y = round(snapped_origin_px.y / cell_size_px) * cell_size_px

	var snapped_rect = Rect2(snapped_origin_px + piece.bounding_rect_px.position, piece.bounding_rect_px.size)
	var board_rect = Rect2(Vector2.ZERO, size_px)

	if board_rect.encloses(snapped_rect):
		piece.origin_position_grid = Vector2i((snapped_origin_px / cell_size_px))
		piece.state = piece.State.IN_BOARD

		# Check for collisions with other pieces and clear them
		var overlapped_pieces = []
		for block in piece.blocks:
			var block_position_grid = piece.origin_position_grid + Vector2i(block)
			var overlapped_piece = data[block_position_grid]["piece"]
			if overlapped_piece == null:
				continue
			if overlapped_piece in overlapped_pieces:
				continue
			overlapped_pieces.append(overlapped_piece)
			
		for overlapped_piece in overlapped_pieces:
			for block in overlapped_piece.blocks:
				var block_position_grid = overlapped_piece.origin_position_grid + Vector2i(block)
				data[block_position_grid]["piece"] = null
			overlapped_piece.state = overlapped_piece.State.IN_PALETTE

		# Update data for each block in the piece
		for block_position_grid in piece.blocks:
			data[piece.origin_position_grid + Vector2i(block_position_grid)]["piece"] = piece
	else:
		piece.state = piece.State.IN_PALETTE

	check_for_solution()
	place_palette_pieces()

@onready var tween: Tween
func check_for_solution() -> void:
	if tween:
		tween.kill()
	tween = create_tween()

	for element: Element in elements:
		element.initialise(self)

	for piece: Piece in pieces:
		if piece.state == piece.State.IN_PALETTE:
			return
	
	var valid = true
	for element: Element in elements:
		if not element.check(data):
			valid = false
			var original_colour = element.colour
			element.colour = Colours.RED
			tween.parallel().tween_property(element, "colour", original_colour, 5)

	if valid:
		valid_solution.emit()
	else:
		invalid_solution.emit()

func _on_piece_picked_up(piece):
	for cell in data:
		if data[cell]["piece"] == piece:
			data[cell]["piece"] = null

func _draw() -> void:
	# Draw grid lines
	for x in range(size_grid.x + 1):
		var x_pos = x * cell_size_px
		draw_line(Vector2(x_pos, 0), Vector2(x_pos, size_px.y), Colours.YELLOW, line_thickness)
	for y in range(size_grid.y + 1):
		var y_pos = y * cell_size_px
		draw_line(Vector2(0, y_pos), Vector2(size_px.x, y_pos), Colours.YELLOW, line_thickness)

func place_palette_pieces() -> void:
	var palette_pieces = []
	for piece: Piece in pieces:
		if piece.state == Piece.State.IN_PALETTE:
			palette_pieces.append(piece)

	# Place each piece diag_px / 2+ piece.bounding_rect_px.size.length() away fromm (0, 0), and rotate this vector by 2*PI/palette_pieces.size()*index
	var angle_step = 2 * PI / palette_pieces.size()
	for i in range(palette_pieces.size()):
		var piece = palette_pieces[i]
		var angle = angle_step * i
		var piece_new_position_px = Vector2(cos(angle), -sin(angle)) * (diag_px + piece.bounding_rect_px.size.length() / 2) / 2 - piece.bounding_rect_px.position + Vector2(cell_size_px, cell_size_px)
		piece.global_position = piece_new_position_px			
