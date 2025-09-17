class_name Piece extends Node2D

signal piece_picked_up(piece)
signal piece_placed(piece)

var initial_data: PieceData
var blocks: Array[Vector2i]

var cell_size_px: int

var area2d: Area2D

enum State { IN_PALETTE, PICKED_UP, IN_BOARD }
var state: State = State.IN_PALETTE

var origin_position_grid: Vector2i

func _ready() -> void:
	blocks = initial_data.blocks

	for boundary_point in initial_data.boundary:
		boundary.append(boundary_point*cell_size_px)

	calculate_bounding_rect()
	create_area2d()
	area2d.mouse_entered.connect(_on_mouse_entered)
	area2d.mouse_exited.connect(_on_mouse_exited)
	area2d.input_event.connect(_on_input_event)

	# const offset_range = 0.3
	# var colour_offset = Color(randf_range(-offset_range, offset_range), randf_range(-offset_range, offset_range), randf_range(-offset_range, offset_range))
	colour = Colours.YELLOW # + colour_offset

	connect("piece_picked_up", play_pick_up)
	connect("piece_placed", play_place)
func play_pick_up(_self) -> void:
	Audio.play_sfx(Audio.SFX.PICK_UP)
func play_place(_self) -> void:
	Audio.play_sfx(Audio.SFX.PLACE)

var bounding_rect_px: Rect2
func calculate_bounding_rect() -> void:
	var top_left = Vector2(INF, INF)
	var bottom_right = Vector2(-INF, -INF)
	for block_pos in blocks:
		top_left.x = min(top_left.x, block_pos.x)
		top_left.y = min(top_left.y, block_pos.y)
		bottom_right.x = max(bottom_right.x, block_pos.x)
		bottom_right.y = max(bottom_right.y, block_pos.y)
	bounding_rect_px = Rect2((top_left) * cell_size_px, (bottom_right - top_left + Vector2.ONE) * cell_size_px)

func create_area2d() -> void:
	if area2d:
		for child in area2d.get_children():
			child.queue_free()
	else:
		area2d = Area2D.new()
		add_child(area2d)

	for block_pos in blocks:
		var collision = CollisionShape2D.new()
		var shape = RectangleShape2D.new()
		shape.size = Vector2(cell_size_px, cell_size_px)
		collision.shape = shape
		collision.position = Vector2(block_pos) * cell_size_px + Vector2(cell_size_px, cell_size_px) / 2
		area2d.add_child(collision)

var line_thickness: int
var colour: Color
var boundary: Array[Vector2i] = []
var line_colour: Color = Colours.BLUE
func _draw() -> void:
	for block_pos in blocks:
		var local_pos = Vector2(block_pos * cell_size_px)
		draw_rect(Rect2(local_pos + Vector2(line_thickness, line_thickness) * 2, Vector2(cell_size_px, cell_size_px) - Vector2(line_thickness, line_thickness) * 4), colour)
	
	draw_multiline(boundary, line_colour, line_thickness * 2)

func _on_mouse_entered() -> void:
	# Optional: highlight or change appearance
	modulate = Color(1, 1, 0.8)

func _on_mouse_exited() -> void:
	modulate = Color(1, 1, 1)

func _on_input_event(_viewport, event, _shape_idx) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if state != State.PICKED_UP:
			# Emit signal to notify that the piece is picked up
			for piece in get_parent().board.pieces:
				if piece.state == Piece.State.PICKED_UP:
					piece.state = Piece.State.IN_PALETTE
			emit_signal("piece_picked_up", self)
			state = State.PICKED_UP
			modulate = Color(1, 1, 0.5) # Change appearance when picked up
		else: 
			# Emit the signal to notify that the piece is placed
			# Let either the board or the palette detect where it is
			emit_signal("piece_placed", self)

	elif event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_RIGHT:
		if state != State.IN_BOARD:
			rotate_piece()

func rotate_piece() -> void:
	# Rotate the piece initial_data blocks by 90 degrees clockwise
	var new_blocks: Array[Vector2i] = []
	for block in blocks:
		# Godot's y-axis is flipped
		new_blocks.append(Vector2i(-block.y, block.x))
	blocks = new_blocks
	calculate_bounding_rect()
	create_area2d()

	var new_boundary: Array[Vector2i] = []
	for point in boundary:
		new_boundary.append(Vector2i(-point.y, point.x) + Vector2i(cell_size_px, 0))
	boundary = new_boundary

	queue_redraw()

func _process(_delta):
	match state:
		State.PICKED_UP:
			global_position = get_parent().camera.get_mouse_position_world_px() + Vector2(blocks[0] * cell_size_px) - Vector2(cell_size_px, cell_size_px) / 2
		State.IN_BOARD:
			global_position = Vector2(origin_position_grid * cell_size_px)
		_:
			pass

func move_out_of_board() -> void:
	# if the piece rect intersects the board, move it along the piece's centre - board centre direction
	var board_rect = get_parent().board.rect_px
	var global_rect = Rect2(global_position + bounding_rect_px.position, bounding_rect_px.size)
	if board_rect.intersects(global_rect):
		var direction = (global_rect.position - get_parent().board.size_px / 2 ).normalized()
		global_position += direction * 50
	
	global_rect = Rect2(global_position + bounding_rect_px.position, bounding_rect_px.size)
	if board_rect.intersects(global_rect):
		move_out_of_board()
