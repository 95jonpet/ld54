class_name Piece
extends Area2D

@onready var sprite := $Sprite2D as Sprite2D
@onready var particles := $GPUParticles2D as GPUParticles2D
@onready var collision_shape := $CollisionShape2D as CollisionShape2D


func set_texture(texture: Texture2D):
	sprite.texture = texture


func set_particles(emitting: bool):
	particles.emitting = emitting


func get_size() -> Vector2:
	return collision_shape.shape.get_rect().size
