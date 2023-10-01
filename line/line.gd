class_name Line
extends Node2D


func is_full(max_count: int) -> bool:
	return get_child_count() >= max_count
