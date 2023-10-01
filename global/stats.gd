extends Node


signal level_changed(new_level: int, old_level: int)
signal score_changed(new_score: int, old_score: int)


var level: int = 1 : set = _set_level
var score: int = 0 : set = _set_score


func _set_level(value: int) -> void:
	if level == value:
		return

	var old_level := level
	level = value
	level_changed.emit(level, old_level)


func _set_score(value: int) -> void:
	if score == value:
		return

	var old_score := score
	score = value
	score_changed.emit(score, old_score)

	level = floori(score / 2500.0 + 1)
