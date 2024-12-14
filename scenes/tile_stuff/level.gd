extends Node2D


func _ready() -> void:
	Global.tiles = $wall
	Global.floor_tiles = $floor


func _on_void_area_2_body_entered(body: Node2D) -> void:
	if body is Player:
		body.die()


func _on_void_area_body_entered(body: Node2D) -> void:
	if body is Player:
		body.die()
