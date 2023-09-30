class_name Line
extends Node2D


func is_line_full(max_count: int) -> bool:
	return max_count == get_child_count()
