extends Node


const SPAWN_SOUND: AudioStream = preload("res://world/spawn.wav")
const NEXT_INDICATOR_POSITION := Vector2(64, 16)

var current_tetromino: Shared.Tetromino
var queue: Array[Shared.Tetromino] = []

var spawn_position := Vector2(-Constants.TILE_SIZE / 2.0, Constants.MIN_Y)

var is_game_over := false

@onready var board := $"../Board" as Board
@onready var ui := $"../UI" as UI


func _ready() -> void:
	_randomize_queue()
	while queue.front() == Shared.Tetromino.Explosive:
		_randomize_queue()
	current_tetromino = queue.pop_front()
	AudioPlayer.play(SPAWN_SOUND)
	board.spawn_tetromino(current_tetromino, false, spawn_position)
	board.spawn_tetromino(queue.front(), true, NEXT_INDICATOR_POSITION)
	board.tetromino_locked.connect(_on_tetromino_locked)
	board.game_over.connect(_on_game_over)


func _on_game_over() -> void:
	is_game_over = true
	ui.show_game_over()


func _on_tetromino_locked(_tetromino: Tetromino) -> void:
	if is_game_over:
		return

	# Move the window.
	board.shutter.move_window()
	spawn_position = board.shutter.get_spawn_position()

	# Spawn the queued tetromino and enqueue a new one.
	current_tetromino = queue.pop_front()
	if queue.is_empty():
		_randomize_queue()
	AudioPlayer.play(SPAWN_SOUND)
	board.spawn_tetromino(current_tetromino, false, spawn_position)
	board.spawn_tetromino(queue.front(), true, NEXT_INDICATOR_POSITION)


func _randomize_queue() -> void:
	for type in Shared.Tetromino.values().duplicate():
		queue.push_back(type as Shared.Tetromino)
	queue.shuffle()
