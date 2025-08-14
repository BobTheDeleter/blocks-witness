class_name Piece extends Node2D

signal piece_picked_up(piece)
signal piece_placed(piece)

@export var initial_data: PieceData
@onready var blocks: PackedVector2Array = initial_data.blocks

var area2d: Area2D

enum State { IN_PALETTE, PICKED_UP, IN_BOARD }
var state: State = State.IN_PALETTE

var origin_position_grid: Vector2i

func _ready() -> void:
	calculate_bounding_rect()
	create_area2d()
	area2d.mouse_entered.connect(_on_mouse_entered)
	area2d.mouse_exited.connect(_on_mouse_exited)
	area2d.input_event.connect(_on_input_event)


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
		collision.position = block_pos * cell_size_px + Vector2(cell_size_px, cell_size_px) / 2
		area2d.add_child(collision)

@onready var board = %board
@onready var cell_size_px = %board.cell_size_px
@onready var line_thickness = %board.line_thickness
func _draw() -> void:
	for block_pos in blocks:
		var local_pos = block_pos * cell_size_px
		draw_rect(Rect2(local_pos+Vector2(line_thickness, line_thickness), Vector2(cell_size_px - line_thickness * 2, cell_size_px - line_thickness * 2)), Colours.YELLOW)

func _on_mouse_entered() -> void:
	# Optional: highlight or change appearance
	modulate = Color(1, 1, 0.8)

func _on_mouse_exited() -> void:
	modulate = Color(1, 1, 1)

func _on_input_event(_viewport, event, _shape_idx) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if state != State.PICKED_UP:
			# Emit signal to notify that the piece is picked up
			for piece in board.pieces:
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
	var new_blocks = PackedVector2Array()
	for block in blocks:
		# Godot's y-axis is flipped
		new_blocks.append(Vector2(-block.y, block.x))
	blocks = new_blocks
	calculate_bounding_rect()
	create_area2d()
	queue_redraw()

func _process(_delta):
	match state:
		State.PICKED_UP:
			global_position = %camera.get_mouse_position_world_px() + blocks[0] * cell_size_px - Vector2(cell_size_px, cell_size_px) / 2
		State.IN_PALETTE:
			var global_rect = Rect2(global_position + bounding_rect_px.position, bounding_rect_px.size)
			if board.rect_px.intersects(global_rect):
				var dir = (global_rect.position + global_rect.size / 2).normalized()
				if dir == Vector2.ZERO:
					dir = Vector2(1, 0)
				global_position += dir * board.diag_px * 0.2
		State.IN_BOARD:
			global_position = Vector2(origin_position_grid * cell_size_px)
		_:
			pass
