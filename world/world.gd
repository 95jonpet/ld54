class_name World
extends Node2D


const GAME_OVER_SOUND: AudioStream = preload("res://world/game_over.wav")

@onready var grid_texture := $GridTexture as TextureRect


func _ready() -> void:
	grid_texture.size = Constants.GRID_SIZE * Constants.TILE_SIZE
	grid_texture.position = -grid_texture.size / 2.0


func _on_board_game_over() -> void:
	AudioPlayer.play(GAME_OVER_SOUND)
