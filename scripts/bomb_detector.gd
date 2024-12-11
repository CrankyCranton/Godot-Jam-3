extends Area2D

var tile_position:Vector2i = Vector2i()

func _ready() -> void:
	tile_position = Global.tiles.local_to_map(global_position)

func _on_area_entered(area: Area2D) -> void:
	print("hello")
	Global.tiles.erase_cell(tile_position)
	queue_free()
