class_name Element
extends Node2D

var position_grid: Vector2i

enum TYPE {
	COVERED,
	NOT_COVERED,
	PARTITION_DOT,
	SPACE_AMOUNT,
	PIECE_AMOUNT,
}
# var type: TYPE
# to be defined in each subclass
var colour: Color:
	set(value):
		colour = value
		queue_redraw()

# func initialise(_board: Board) -> void: 
#	pass

# func _draw() -> void:
#	pass

# func check(_board_data) -> bool:
#	return false
