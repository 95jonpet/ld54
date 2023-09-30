extends Node


var current_tetromino: Shared.Tetromino
var next_tetromino: Shared.Tetromino

var spawn_position := Vector2(-Constants.TILE_SIZE / 2.0, Constants.MIN_Y)

var is_game_over := false

@onready var board := $"../Board" as Board
@onready var ui := $"../UI" as UI


func _ready() -> void:
	current_tetromino = Shared.Tetromino.values().pick_random()
	next_tetromino = Shared.Tetromino.values().pick_random()
	board.spawn_tetromino(current_tetromino, false, spawn_position)
	board.spawn_tetromino(next_tetromino, true, Vector2(68, 16))
	board.tetromino_locked.connect(_on_tetromino_locked)
	board.game_over.connect(_on_game_over)


func _on_game_over() -> void:
	is_game_over = true
	ui.show_game_over()


func _on_tetromino_locked(_tetromino: Tetromino) -> void:
	if is_game_over:
		return

	current_tetromino = next_tetromino
	next_tetromino = Shared.Tetromino.values().pick_random()
	board.spawn_tetromino(current_tetromino, false, spawn_position)
	board.spawn_tetromino(next_tetromino, true, Vector2(68, 16))
