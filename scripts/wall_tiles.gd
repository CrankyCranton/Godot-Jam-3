class_name WallTiles extends TileMapLayer


func _ready() -> void:
	for cell in get_used_cells():
		var tile_data := get_cell_tile_data(cell)
		if tile_data:
			var SCENE: PackedScene = tile_data.get_custom_data("scene")
			if SCENE:
				var instance: Node2D = SCENE.instantiate()
				instance.position = map_to_local(cell)
				add_child(instance)
				if instance is Wall:
					instance.init(
						tile_data.get_terrain_peering_bit(TileSet.CELL_NEIGHBOR_TOP_SIDE),
						get_cell_atlas_coords(cell) * tile_set.tile_size
					)

				set_cell(cell)
