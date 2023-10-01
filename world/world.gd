class_name World
extends Node2D


const GAME_OVER_SOUND: AudioStream = preload("res://world/game_over.wav")

@onready var grid_texture := $GridTexture as TextureRect
@onready var score_label := $RightPanelContainer/MarginContainer/VBoxContainer/ScoreLabel as Label
@onready var level_label := $RightPanelContainer/MarginContainer/VBoxContainer/LevelLabel as Label


func _ready() -> void:
	grid_texture.size = Constants.GRID_SIZE * Constants.TILE_SIZE
	grid_texture.position = -grid_texture.size / 2.0

	Stats.level_changed.connect(_on_level_changed)
	Stats.score_changed.connect(_on_score_changed)


func _on_board_game_over() -> void:
	AudioPlayer.play(GAME_OVER_SOUND)


func _on_level_changed(new_level: int, _old_level: int) -> void:
	level_label.text = str(new_level)


func _on_score_changed(new_score: int, _old_score: int) -> void:
	score_label.text = str(new_score)
