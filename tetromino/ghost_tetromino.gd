class_name GhostTetromino
extends Node2D


@onready var piece_scene = preload("res://tetromino/piece.tscn") as PackedScene
@onready var ghost_texture = preload("res://tetromino/tetromino_ghost.png") as Texture2D

var data: TetrominoData

func _ready() -> void:
	for cell in Shared.cells[data.tetromino_type]:
		var piece := piece_scene.instantiate() as Piece
		add_child(piece)
		piece.set_texture(ghost_texture)
		piece.set_particles(data.tetromino_type == Shared.Tetromino.Explosive)
		piece.position = Vector2(cell) * piece.get_size()


func set_ghost_tetromino(new_position: Vector2, piece_positions: Array[Vector2]) -> void:
	global_position = new_position
	var pieces = get_children()
	for i in pieces.size():
		pieces[i].position = piece_positions[i]
