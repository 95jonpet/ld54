extends Node

enum Tetromino {
	I, O, T, J, L, S, Z, Explosive
}

var cells = {
	Tetromino.I: [Vector2i(-1, 0), Vector2i(0, 0), Vector2i(1, 0), Vector2i(2, 0)],
	Tetromino.J: [Vector2i(-1, 1), Vector2i(-1, 0), Vector2i(0, 0), Vector2i(1, 0)],
	Tetromino.L: [Vector2i(1, 1), Vector2i(-1, 0), Vector2i(0, 0), Vector2i(1, 0)],
	Tetromino.O: [Vector2i(0, 1), Vector2i(1, 1), Vector2i(0, 0), Vector2i(1, 0)],
	Tetromino.S: [Vector2i(0, 1), Vector2i(1, 1), Vector2i(-1, 0), Vector2i(0, 0)],
	Tetromino.T: [Vector2i(0, 1), Vector2i(-1, 0), Vector2i(0, 0), Vector2i(1, 0)],
	Tetromino.Z: [Vector2i(-1, 1), Vector2i(0, 1), Vector2i(0, 0), Vector2i(1, 0)],
	Tetromino.Explosive: [Vector2i(0, 1), Vector2i(1, 1), Vector2i(0, 0), Vector2i(1, 0)],
}

var wall_kicks_i = [
	[Vector2i(0, 0), Vector2i(-2, 0), Vector2i(1, 0), Vector2i(-2, -1), Vector2i(1, 2)],
	[Vector2i(0, 0), Vector2i(2, 0), Vector2i(-1, 0), Vector2i(2, 1), Vector2i(-1, -2)],
	[Vector2i(0, 0), Vector2i(-1, 0), Vector2i(2, 0), Vector2i(-1, 2), Vector2i(2, -1)],
	[Vector2i(0, 0), Vector2i(1, 0), Vector2i(-2, 0), Vector2i(1, -2), Vector2i(-2, 1)],
	[Vector2i(0, 0), Vector2i(2, 0), Vector2i(-1, 0), Vector2i(2, 1), Vector2i(-1, -2)],
	[Vector2i(0, 0), Vector2i(-2, 0), Vector2i(1, 0), Vector2i(-2, -1), Vector2i(1, 2)],
	[Vector2i(0, 0), Vector2i(1, 0), Vector2i(-2, 0), Vector2i(1, -2), Vector2i(-2, 1)],
	[Vector2i(0, 0), Vector2i(-1, 0), Vector2i(2, 0), Vector2i(-1, 2), Vector2i(2, -1)]
]

var wall_kicks_jlostz = [
	[Vector2i(0, 0), Vector2i(-1, 0), Vector2i(-1, 1), Vector2i(0, -2), Vector2i(-1, -2)],
	[Vector2i(0, 0), Vector2i(1, 0), Vector2i(1, -1), Vector2i(0, 2), Vector2i(1, 2)],
	[Vector2i(0, 0), Vector2i(1, 0), Vector2i(1, -1), Vector2i(0, 2), Vector2i(1, 2)],
	[Vector2i(0, 0), Vector2i(-1, 0), Vector2i(-1, 1), Vector2i(0, -2), Vector2i(-1, -2)],
	[Vector2i(0, 0), Vector2i(1, 0), Vector2i(1, 1), Vector2i(0, -2), Vector2i(1, -2)],
	[Vector2i(0, 0), Vector2i(-1, 0), Vector2i(-1, -1), Vector2i(0, 2), Vector2i(-1, 2)],
	[Vector2i(0, 0), Vector2i(-1, 0), Vector2i(-1, -1), Vector2i(0, 2), Vector2i(-1, 2)],
	[Vector2i(0, 0), Vector2i(1, 0), Vector2i(1, 1), Vector2i(0, -2), Vector2i(1, -2)]
]

var data = {
	Tetromino.I: preload("res://resources/i_piece_data.tres"),
	Tetromino.J: preload("res://resources/j_piece_data.tres"),
	Tetromino.L: preload("res://resources/l_piece_data.tres"),
	Tetromino.O: preload("res://resources/o_piece_data.tres"),
	Tetromino.S: preload("res://resources/s_piece_data.tres"),
	Tetromino.T: preload("res://resources/t_piece_data.tres"),
	Tetromino.Z: preload("res://resources/z_piece_data.tres"),
	Tetromino.Explosive: preload("res://resources/explosive_piece_data.tres"),
}

var clockwise_rotation_matrix = [Vector2i(0, -1), Vector2i(1, 0)]
var counter_clockwise_rotation_matrix = [Vector2i(0, 1), Vector2i(-1, 0)]
