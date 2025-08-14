class_name LevelData
extends Resource

@export_category("Level Data")
@export var board_size: Vector2i
@export var pieces: Array[PieceData]

@export_category("Visuals")
@export var line_thickness: int
@export var cell_size_px: int
@export var piece_spacing_multiplier: float = 1.0