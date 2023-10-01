extends Node


const SPAWN_SOUND: AudioStream = preload("res://world/spawn.wav")
const NEXT_INDICATOR_POSITION := Vector2(72, 32)

var current_tetromino: Shared.Tetromino
var queue: Array[Shared.Tetromino] = []
var explosive_queue: Array[bool] = []

var spawn_position := Vector2(-Constants.TILE_SIZE / 2.0, Constants.MIN_Y)

var is_game_over := false

@onready var board := $"../Board" as Board
@onready var ui := $"../UI" as UI


func _ready() -> void:
	_randomize_queue()
	while explosive_queue.front():
		_randomize_queue()
	AudioPlayer.play(SPAWN_SOUND)
	current_tetromino = queue.pop_front()
	board.spawn_tetromino(current_tetromino, false, spawn_position, explosive_queue.pop_front())
	board.spawn_tetromino(queue.front(), true, NEXT_INDICATOR_POSITION, explosive_queue.front())
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
	var explosive := explosive_queue.pop_front() as bool
	if queue.is_empty():
		_randomize_queue()
	AudioPlayer.play(SPAWN_SOUND)
	board.spawn_tetromino(current_tetromino, false, spawn_position, explosive)
	board.spawn_tetromino(queue.front(), true, NEXT_INDICATOR_POSITION, explosive_queue.front())


func _randomize_queue() -> void:
	for type in Shared.Tetromino.values().duplicate():
		queue.push_back(type as Shared.Tetromino)
		explosive_queue.push_back(false)
	queue.shuffle()

	explosive_queue.pop_back()
	explosive_queue.push_back(true)
	explosive_queue.shuffle()
