class_name PieceData extends Resource

@export var blocks: Array[Vector2i]:
	set(value):
		blocks = value
		generate_boundary_points()
var boundary: Array[Vector2i] = []

enum PIECE_TYPE {
	NORMAL
}
@export var type: PIECE_TYPE

func generate_boundary_points() -> void:
	boundary.clear()
	for block in blocks:
		if not blocks.has(block + Vector2i(0, -1)):
			boundary.append(block)
			boundary.append(block + Vector2i(1, 0))
		if not blocks.has(block + Vector2i(0, 1)):
			boundary.append(block + Vector2i(0, 1))
			boundary.append(block + Vector2i(1, 1))
		if not blocks.has(block + Vector2i(-1, 0)):
			boundary.append(block)
			boundary.append(block + Vector2i(0, 1))
		if not blocks.has(block + Vector2i(1, 0)):
			boundary.append(block + Vector2i(1, 0))
			boundary.append(block + Vector2i(1, 1))