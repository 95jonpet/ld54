class_name Game
extends Node


@onready var camera: Camera2D = $Camera


const MUSIC: Array[AudioStream] = [
	preload("res://music/song_20231001_142831_513.mp3"),
	preload("res://music/song_20231001_090819_092.mp3"),
]


func _ready() -> void:
	MusicPlayer.play(MUSIC)


func _process(delta: float) -> void:
	camera.offset = ScreenShake.get_noise_offset(delta)
