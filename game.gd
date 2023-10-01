class_name Game
extends Node


const MUSIC: Array[AudioStream] = [
	preload("res://music/song_20231001_142831_513.mp3"),
	preload("res://music/song_20231001_090819_092.mp3"),
]


func _ready() -> void:
	MusicPlayer.play(MUSIC)
