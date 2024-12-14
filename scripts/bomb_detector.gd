extends Area2D

var tile_position:Vector2i = Vector2i()

func _ready() -> void:
	tile_position = Global.tiles.local_to_map(global_position)

func _on_area_entered(area: Area2D) -> void:
	Global.tiles.erase_cell(tile_position)
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	#await get_tree().create_timer(0.1).timeout
	if body is Grenade:
		body._explode()
