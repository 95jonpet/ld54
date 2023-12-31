class_name Tetromino
extends Node2D


signal locked()


const EXPLOSIVE_PIECE_TEXTURE: Texture2D = preload("res://tetromino/tetromino_white.png")

const EXPLODE_SOUND: AudioStream = preload("res://tetromino/sound_explode.wav")
const HARD_DROP_SOUND: AudioStream = preload("res://tetromino/sound_hard_drop.wav")
const LOCK_SOUND: AudioStream = preload("res://tetromino/sound_lock.wav")
const MOVE_SOUND: AudioStream = preload("res://tetromino/sound_move.wav")
const MOVE_AUTO_SOUND: AudioStream = preload("res://tetromino/sound_move_auto.wav")
const ROTATE_SOUND: AudioStream = preload("res://tetromino/sound_rotate.wav")

var rotation_index: int = 0
var wall_kicks
var data: TetrominoData
var bounds: Rect2 = Rect2(0, 0, 0, 0)
var is_next_piece: bool
var pieces: Array[Piece] = []
var other_tetromino_pieces: Array[Piece] = []
var ghost_tetromino: GhostTetromino

var cells: Array

@onready var piece_scene := preload("res://tetromino/piece.tscn") as PackedScene
@onready var ghost_tetromino_scene := preload("res://tetromino/ghost_tetromino.tscn") as PackedScene
@onready var timer := $Timer as Timer


func _ready() -> void:
	cells = Shared.cells[data.tetromino_type].duplicate()
	for cell in cells:
		var piece := piece_scene.instantiate() as Piece
		pieces.append(piece)
		add_child(piece)
		piece.set_texture(EXPLOSIVE_PIECE_TEXTURE if data.explosive else data.piece_texture)
		piece.set_particles(data.explosive)
		piece.position = Vector2(cell) * piece.get_size()

	timer.wait_time = _wait_time_for_level(Stats.level)
	timer.start()

	if not is_next_piece:
		wall_kicks = Shared.wall_kicks_i if data.tetromino_type == Shared.Tetromino.I else Shared.wall_kicks_jlostz
		ghost_tetromino = ghost_tetromino_scene.instantiate() as GhostTetromino
		ghost_tetromino.data = data.duplicate()
		get_tree().root.add_child.call_deferred(ghost_tetromino)
		hard_drop_ghost()
	else:
		timer.stop()
		set_process_input(false)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("hard_drop"):
		hard_drop()
	elif event.is_action_pressed("move_left"):
		if move(Vector2.LEFT):
			AudioPlayer.play(MOVE_SOUND)
	elif event.is_action_pressed("move_right"):
		if move(Vector2.RIGHT):
			AudioPlayer.play(MOVE_SOUND)
	elif event.is_action_pressed("move_down"):
		if move(Vector2.DOWN):
			AudioPlayer.play(MOVE_SOUND)
			timer.start()
		else:
			lock()
	elif event.is_action_pressed("rotate_left"):
		rotate_tetromino(-1)
	elif event.is_action_pressed("rotate_right"):
		rotate_tetromino(1)


func _on_timer_timeout() -> void:
	var should_lock := not move(Vector2.DOWN)
	if should_lock:
		lock()
	else:
		AudioPlayer.play(MOVE_AUTO_SOUND)


func move(direction: Vector2) -> bool:
	var new_position := calculate_global_position(global_position, direction)
	if new_position == Vector2.INF:
		return false
	global_position = new_position

	if direction != Vector2.DOWN:
		hard_drop_ghost.call_deferred()

	return true


func rotate_tetromino(direction: int) -> void:
	# Rotating an O-type tetromino (a 2x2 square) is a no-op.
	if data.tetromino_type == Shared.Tetromino.O:
		return

	var original_rotation_index = rotation_index
	_apply_rotation(direction)
	var rotated := true

	rotation_index = wrapi(rotation_index + sign(direction), 0, 4)

	if not test_wall_kicks(rotation_index, direction):
		rotation_index = original_rotation_index
		_apply_rotation(-direction)
		rotated = false

	if rotated:
		AudioPlayer.play(ROTATE_SOUND)

	hard_drop_ghost.call_deferred()


func hard_drop() -> void:
	var moved := false
	while move(Vector2.DOWN):
		moved = true
	if moved:
		AudioPlayer.play(HARD_DROP_SOUND)
	lock()


func hard_drop_ghost() -> Vector2:
	var hard_drop_position := global_position
	while hard_drop_position != Vector2.INF:
		var ghost_position_update := calculate_global_position(hard_drop_position, Vector2.DOWN)
		if ghost_position_update == Vector2.INF:
			break
		hard_drop_position = ghost_position_update

	if hard_drop_position == Vector2.INF:
		return hard_drop_position

	var children := get_children().filter(func (c): return c is Piece)
	var piece_positions: Array[Vector2] = []
	for i in children.size():
		piece_positions.append(children[i].position)

	ghost_tetromino.set_ghost_tetromino(hard_drop_position, piece_positions)

	return hard_drop_position



func lock() -> void:
	if data.explosive:
		ScreenShake.apply_shake(8.0)
		AudioPlayer.play(EXPLODE_SOUND)
		_destroy_touching_pieces()
		for piece in pieces:
			piece.free()
		queue_free()
	else:
		AudioPlayer.play(LOCK_SOUND)

	timer.stop()
	locked.emit()
	ghost_tetromino.queue_free()
	set_process_input(false)
	Stats.score += 1


func calculate_global_position(global_starting_position: Vector2, direction: Vector2) -> Vector2:
	if is_colliding_with_other_tetrominos(global_starting_position, direction):
		return Vector2.INF

	if not is_within_bounds(global_starting_position, direction):
		return Vector2.INF

	return global_starting_position + direction * pieces[0].get_size()


func is_colliding_with_other_tetrominos(global_starting_position: Vector2, direction: Vector2) -> bool:
	for other_piece in other_tetromino_pieces:
		for piece in pieces:
			if global_starting_position + piece.position + direction * piece.get_size() == other_piece.global_position:
				return true
	return false


func is_within_bounds(global_starting_position: Vector2, direction: Vector2) -> bool:
	for piece in pieces:
		var new_position = piece.position + global_starting_position + direction * piece.get_size()
		if not bounds.has_point(new_position):
			return false
	return true


func test_wall_kicks(test_rotation_index: int, test_rotation_direction: int) -> bool:
	var wall_kick_index := _get_wall_kick_index(test_rotation_index, test_rotation_direction)

	for i in wall_kicks[0].size():
		var translation = wall_kicks[wall_kick_index][i]
		if move(translation):
			return true
	return false


func _apply_rotation(direction: int) -> void:
	var rotation_matrix = Shared.clockwise_rotation_matrix if direction >= 0  else Shared.counter_clockwise_rotation_matrix

	# TODO: Rotate around tetromino origin instead.
	for i in cells.size():
		var coordinates = rotation_matrix[0] * cells[i].x + rotation_matrix[1] * cells[i].y
		cells[i] = coordinates

	for i in pieces.size():
		var piece := pieces[i]
		piece.position = Vector2(cells[i]) * piece.get_size()


func _get_wall_kick_index(test_rotation_index: int, test_rotation_direction: int) -> int:
	var wall_kick_index = test_rotation_index * 2
	if test_rotation_direction < 0:
		wall_kick_index -= 1
	return wrapi(wall_kick_index, 0, wall_kicks.size())


func _destroy_touching_pieces() -> void:
	var pieces_to_delete = []
	for piece in pieces:
		for other_piece in other_tetromino_pieces.duplicate():
			if piece.global_position.distance_squared_to(other_piece.global_position) <= Constants.TILE_SIZE * Constants.TILE_SIZE:
				pieces_to_delete.append(other_piece)
	for other_piece in pieces_to_delete:
		if not is_instance_valid(other_piece):
			continue
		other_piece.free()

	Stats.score += pieces_to_delete.size() * 10


func _wait_time_for_level(level: int) -> float:
	const max_time := 1.0
	const min_time := 0.125
	const steps := 25.0
	const level_diff = (max_time - min_time) / steps
	return clampf(max_time - (level - 1) * level_diff, min_time, max_time)
