class_name Wall extends StaticBody2D


@export var debris: Array[PackedScene] = []

var destroyed := false
var walls := {}

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var light: PointLight2D = $Light
@onready var sprite: Sprite2D = $Sprite
@onready var collision_shape: CollisionShape2D = $CollisionShape


func init(wall: bool, texture_coords: Vector2, polygons: Array[PackedVector2Array]) -> void:
	set_collision(polygons)
	light.visible = wall
	sprite.region_rect.position = texture_coords
	#collision_shape.disabled = not wall


func set_collision(polygons: Array[PackedVector2Array]) -> void:
	for polygon in polygons:
		var collision_poloygon := CollisionPolygon2D.new()
		collision_poloygon.polygon = polygon
		add_child(collision_poloygon)


func explode() -> void:
	if not destroyed:
		destroyed = true
		animation_player.play(&"explode")
		queue_free()
