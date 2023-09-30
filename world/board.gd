class_name Board
extends Node


signal game_over()
signal tetromino_locked(tetromino: Tetromino)


const ROWS := 10
const COLUMNS := 10

@export var tetromino_scene: PackedScene
var next_tetromino: Tetromino
var tetrominos: Array[Tetromino] = []

@onready var panel_container := $"../PanelContainer" as PanelContainer


func spawn_tetromino(type: Shared.Tetromino, is_next_piece: bool, spawn_position: Vector2) -> void:
	var data := Shared.data[type] as TetrominoData
	var tetromino := tetromino_scene.instantiate() as Tetromino

	tetromino.data = data
	tetromino.is_next_piece = is_next_piece

	if not is_next_piece:
		tetromino.position = spawn_position
		tetromino.other_tetrominos = tetrominos
		tetromino.locked.connect(_on_tetromino_locked.bind(tetromino))
		add_child(tetromino)
	else:
		tetromino.scale = Vector2(0.5, 0.5)
		panel_container.add_child(tetromino)
		tetromino.position = spawn_position
		next_tetromino = tetromino


func _on_tetromino_locked(tetromino: Tetromino) -> void:
	next_tetromino.queue_free()
	tetrominos.append(tetromino)

	_clear_lines()
	if _check_game_over():
		game_over.emit()
	else:
		tetromino_locked.emit(tetromino)


func _check_game_over() -> bool:
	for tetromino in tetrominos:
		var pieces = tetromino.get_children().filter(func (c): return c is Piece)
		for piece in pieces:
			if piece.global_position.y == -72:
				return true
	return false


func _clear_lines() -> void:
	var board_pieces = _fill_board_pieces()
	_clear_board_pieces(board_pieces)


func _fill_board_pieces() -> Array:
	var board_pieces = []

	for row in ROWS:
		board_pieces.append([])

	for tetromino in tetrominos:
		var tetromino_pieces := tetromino.get_children().filter(func(c): return c is Piece)
		for piece in tetromino_pieces:
			var row := roundi((piece.global_position.y + piece.get_size().y / 2.0) / piece.get_size().y + ROWS / 2.0)
			board_pieces[row - 1].append(piece)

	return board_pieces


func _clear_board_pieces(board_pieces: Array) -> void:
	var i := ROWS
	while i > 0:
		var row = board_pieces[i - 1]
		if row.size() == COLUMNS:
			_clear_row(row)
			board_pieces[i - 1].clear()
			_move_all_row_pieces_down(board_pieces, i)
		i -= 1


func _clear_row(row: Array) -> void:
	for piece in row:
		piece.queue_free()


func _move_all_row_pieces_down(board_pieces: Array, cleared_row_number: int) -> bool:
	for i in range(cleared_row_number - 1, 1, -1):
		var row_to_move = board_pieces[i - 1]
		if row_to_move.size() == 0:
			return false  # No need to check further after hitting an empty row.

		for piece in row_to_move:
			piece.position.y += piece.get_size().y
			board_pieces[cleared_row_number - 1].append(piece)
		board_pieces[i - 1].clear()
	return true
