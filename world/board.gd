class_name Board
extends Node


signal game_over()
signal tetromino_locked(tetromino: Tetromino)


const FULL_LINE_SOUND: AudioStream = preload("res://tetromino/sound_full_line.wav")

@export var tetromino_scene: PackedScene
var next_tetromino: Tetromino
var tetrominos: Array[Tetromino] = []

@onready var panel_container := $"../RightPanelContainer" as PanelContainer
@onready var shutter := $"../Shutter" as Shutter

@onready var line_scene := preload("res://line/line.tscn") as PackedScene


func _on_tetromino_locked(tetromino: Tetromino) -> void:
	next_tetromino.queue_free()
	tetrominos.append(tetromino)
	_add_tetromino_to_lines(tetromino)
	_remove_full_lines()

	if _check_game_over():
		ScreenShake.apply_shake(24.0)
		game_over.emit()
	else:
		tetromino_locked.emit(tetromino)

	tetromino.queue_free()


func spawn_tetromino(type: Shared.Tetromino, is_next_piece: bool, spawn_position: Vector2, explosive: bool) -> void:
	var data := Shared.data[type].duplicate() as TetrominoData
	var tetromino := tetromino_scene.instantiate() as Tetromino

	data.explosive = explosive
	tetromino.data = data
	tetromino.bounds = shutter.get_window_bounds()
	tetromino.is_next_piece = is_next_piece
	tetromino.position = spawn_position

	if not is_next_piece:
		tetromino.position += data.spawn_offset
		tetromino.other_tetromino_pieces = get_pieces()
		tetromino.locked.connect(_on_tetromino_locked.bind(tetromino))
		add_child(tetromino)
	else:
		tetromino.scale = Vector2(0.5, 0.5)
		panel_container.add_child(tetromino)
		tetromino.position = spawn_position
		next_tetromino = tetromino
		if data.tetromino_type == Shared.Tetromino.I:
			tetromino.position.y += (tetromino.pieces[0].get_size().y / 2.0) * tetromino.scale.y


func get_lines() -> Array[Line]:
	var lines: Array[Line] = []
	for l in get_children().filter(func (c): return c is Line):
		lines.append(l as Line)
	return lines


func get_pieces() -> Array[Piece]:
	var pieces: Array[Piece] = []
	for line in get_lines():
		pieces.append_array(line.get_children())
	return pieces


func _check_game_over() -> bool:
	for piece in get_pieces():
		if is_equal_approx(piece.global_position.y, -(Constants.TILE_SIZE * Constants.GRID_SIZE.y / 2.0 - Constants.TILE_SIZE / 2.0)):
			return true
	return false


func _add_tetromino_to_lines(tetromino: Tetromino) -> void:
	var pieces = tetromino.get_children().filter(func (c): return c is Piece)
	for piece in pieces:
		var y_position = piece.global_position.y
		var line: Line = null

		for l in get_lines().filter(func (l): return l.global_position.y == y_position):
			line = l
			break

		if not line:
			line = line_scene.instantiate() as Line
			line.global_position = Vector2(0, y_position)
			add_child(line)

		piece.reparent(line)


func _remove_full_lines() -> void:
	var removed_lines := 0
	for line in get_lines():
		if line.is_full(Constants.GRID_SIZE.x):
			_move_lines_down(line.global_position.y)
			line.free()  # Other logic may depend on the line, so it must be removed synchronously.
			AudioPlayer.play(FULL_LINE_SOUND)
			removed_lines += 1

	match removed_lines:
		1:
			Stats.score += 800 * Stats.level
		2:
			Stats.score += 1200 * Stats.level
		3:
			Stats.score += 1800 * Stats.level
		4:
			Stats.score += 2000 * Stats.level


func _move_lines_down(y_position: float) -> void:
	for line in get_lines():
		if line.get_child_count() == 0:
			line.queue_free()
			continue

		if line.global_position.y < y_position:
			line.global_position.y += (line.get_children()[0] as Piece).get_size().y

