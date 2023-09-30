class_name Shutter
extends Node


const CLOSED_ALPHA: float = 0.8
const OPEN_ALPHA: float = 0.0

var window_width: int = roundi(Constants.GRID_SIZE.x / 2.0) : set = _set_window_width
var window_x_pos: int = roundi((Constants.GRID_SIZE.x - window_width) / 2.0) : set = _set_window_x_pos
var blinds: Array[ColorRect] = []


func _ready() -> void:
	for column in range(Constants.GRID_SIZE.x):
		var rect := ColorRect.new()
		rect.position = Vector2(Constants.MIN_X + column * Constants.TILE_SIZE - Constants.TILE_SIZE / 2.0, Constants.MIN_Y - Constants.TILE_SIZE / 2.0)
		rect.size = Vector2(Constants.TILE_SIZE, Constants.MAX_Y - Constants.MIN_Y + Constants.TILE_SIZE)
		rect.color = Color("#1a1c2c")
		rect.modulate.a = OPEN_ALPHA
		add_child(rect)
		blinds.append(rect)
	_update_blinds()


func get_window_bounds() -> Rect2:
	var pos := Vector2(Constants.MIN_X + window_x_pos * Constants.TILE_SIZE - Constants.TILE_SIZE / 2.0, Constants.MIN_Y)
	var size := Vector2((window_width + 1) * Constants.TILE_SIZE, Constants.MAX_Y - Constants.MIN_Y + Constants.TILE_SIZE)
	return Rect2(pos, size)


func get_spawn_position() -> Vector2:
	var bounds := get_window_bounds()
	return Vector2(bounds.get_center().x, bounds.position.y)


func move_window() -> void:
	window_x_pos = wrapi(window_x_pos + 1, 0, floori(Constants.GRID_SIZE.x - window_width))


func _set_window_width(value: int) -> void:
	window_width = value
	_update_blinds()


func _set_window_x_pos(value: int) -> void:
	window_x_pos = value
	_update_blinds()


func _update_blinds() -> void:
	for i in blinds.size():
		var blind = blinds[i]
		var open: bool = i >= window_x_pos and i <= window_x_pos + window_width
		blind.modulate.a = OPEN_ALPHA if open else CLOSED_ALPHA
