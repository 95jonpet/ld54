class_name Tetromino
extends Node2D

var data: TetrominoData
var is_next_piece: bool

var cells


func _ready() -> void:
	cells = Shared.cells[data.tetromino_type]
	for cell in cells:

