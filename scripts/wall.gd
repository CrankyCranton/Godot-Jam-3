class_name Wall extends StaticBody2D


@onready var light: PointLight2D = $Light
@onready var sprite: Sprite2D = $Sprite
@onready var collision_shape: CollisionShape2D = $CollisionShape


func init(wall: bool, texture_coords: Vector2) -> void:
	light.visible = wall
	collision_shape.disabled = not wall
	sprite.region_rect.position = texture_coords
