class_name Line
extends Node2D


func is_line_full(max_count: int, bounds: Rect2) -> bool:
	var pieces: int = get_children().filter(func (c): return bounds.has_point(c.position)).size()
	return pieces >= max_count
