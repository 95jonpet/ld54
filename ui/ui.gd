class_name UI
extends CanvasLayer

@onready var center_container := $CenterContainer as CenterContainer


func _on_button_pressed() -> void:
	get_tree().reload_current_scene()


func show_game_over() -> void:
	center_container.show()
