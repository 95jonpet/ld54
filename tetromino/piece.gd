class_name Piece
extends Area2D


@onready var sprite_2d := $Sprite2D as Sprite2D
@onready var collision_shape_2d := $CollisionShape2D as CollisionShape2D


func set_texture(texture: Texture2D):
	sprite_2d.texture = texture


func get_size() -> Vector2:
	return collision_shape_2d.shape.get_rect().size
