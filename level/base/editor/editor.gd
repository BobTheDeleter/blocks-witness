extends TileMapLayer

@export_category("Board parameters")
@export var board_size: Vector2i

@export_category("Element scenes")
@export var covered_packed_scene: PackedScene
@export var partition_dot_packed_scene: PackedScene
@export var not_covered_packed_scene: PackedScene
@export var space_amount_packed_scene: PackedScene

func generate_elements() -> void:
	for x in board_size.x:
		for y in board_size.y:
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

				element.position_grid = Vector2i(x, y)
				%elements.add_child(element)
	
	%board.size_grid = board_size
	%camera.centre_board(board_size*%board.cell_size_px)
	%board.initialise_board()
	queue_free()
