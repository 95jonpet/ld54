class_name UI
extends CanvasLayer


const GAME_RESTART_SOUND: AudioStream = preload("res://ui/game_restart.wav")

@onready var center_container := $CenterContainer as CenterContainer


func _on_button_pressed() -> void:
	AudioPlayer.play(GAME_RESTART_SOUND)
	get_tree().reload_current_scene()


func show_game_over() -> void:
	center_container.show()
